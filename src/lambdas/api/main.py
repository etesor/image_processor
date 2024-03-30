"""
Lambda function code to process images into smaller resolutions.
"""
# from pydantic import BaseModel
import numpy as np

# class Input(BaseModel):
#     numbers: list[int]

def lambda_handler(event, context):
    """
    Lambda handler, see https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html
    """
    # TODO: Make Pydantic work
    # input: Input = event

    # a = np.unique(input['numbers'])
    bucket = event['Records'][0]['s3']['bucket']['name']
    object_name = event['Records'][0]['s3']['object']['key']
    response = {
        # "unique": a.tolist(),
        "bucket_name": bucket,
        "object_name": object_name,
        "time_left": f'{context.get_remaining_time_in_millis()/100}',
        "function_name": f'{context.function_name}'
    }
    print(response)
    return response