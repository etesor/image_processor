data "archive_file" "function" {
  type = "zip"

  source_dir  = "../../${path.module}/src/lambdas"
  output_path = local.archive_path
  excludes = [ "venv" ]
}

resource "null_resource" "layer_install_deps" {
  provisioner "local-exec" {
    command     = "make install"
    working_dir = abspath("${path.module}/../..")
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

data "archive_file" "layer" {
  type        = "zip"
  source_dir  = "../../${path.module}/layer/modules"
  output_path = local.layer_archive_path

  depends_on = [ null_resource.layer_install_deps ]
}

resource "aws_lambda_layer_version" "layer" {
  filename                 = local.layer_archive_path
  layer_name               = "image_processor-layer"
  compatible_runtimes      = ["python3.12"]
  compatible_architectures = ["x86_64"]
  source_code_hash         = data.archive_file.layer.output_base64sha256

  depends_on = [data.archive_file.layer]

}

resource "aws_lambda_function" "image_processor" {
  function_name = "image_processor"
  role          = aws_iam_role.lambda_exec.arn

  filename         = local.archive_path
  description      = "This function resized images and store the result in a S3 Bucket."
  handler          = "api/main.lambda_handler"
  layers           = [aws_lambda_layer_version.layer.arn]
  runtime          = "python3.12"
  source_code_hash = data.archive_file.function.output_base64sha256

  depends_on = [
    data.archive_file.function,
    data.archive_file.layer
  ]

}

resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${aws_lambda_function.image_processor.function_name}"

  retention_in_days = 5
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

data "aws_iam_policy_document" "lambda_s3" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::*/*"
    ]
  }
  statement {
    actions = [
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::*/*"
    ]
  }
}

resource "aws_iam_policy" "lambda_s3" {
  name = "LambdaS3Policy"
  policy = data.aws_iam_policy_document.lambda_s3.json
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_s3.arn

}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id = "AllowExecutionFromS3Bucket"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.arn
  principal = "s3.amazonaws.com"
  source_arn = aws_s3_bucket.origin.arn
}
