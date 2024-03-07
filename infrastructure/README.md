# Infrastructure

In this folder you'll find the mechanisms to create the AWS infrastructure needed for this project.

## Terraform
Terraform HCL code to deploy the whole application is provided. A remote backend is not setup because this project is intended to be use solely for experimentation purposes. A remote backend configuration will be needed if you want to run this as a production grade application. Details might be added later.

### How to run it
- Get AWS Access Keys to the account you want to deploy. Permissions are not in the scope of this guide, double check IAM policies if Terraform is not able to create resources due to lack of permissions.
- Execute `terraform init` to download required Terraform providers.
- Execute `terraform plan` to verify the changes Terraform _will_ perform.
- Execute `terraform apply`, review the plan again and type _yes_ if the promt ask you to do so in order to allow Terraform to do the planned changes.
- When you're done, execute `terraform destroy`. All IaC resources will be deleted from AWS.

## Cloudformation
TBD

Always remember: _There's no perfect tool. It all depends on the context._


References:
- https://aws.amazon.com/blogs/infrastructure-and-automation/deploying-aws-lambda-functions-using-aws-cloudformation-the-portable-way/
- https://developer.hashicorp.com/terraform/docs