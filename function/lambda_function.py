"""
Lambda function code to process images into smaller resolutions.
"""

def lambda_handler(event, context):
    """
    Lambda handler, see https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html
    """
    
    response = f'My name is {context.function_name}'
    print(response)
    return response