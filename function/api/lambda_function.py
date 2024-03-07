"""
Lambda function code to process images into smaller resolutions.
"""
import numpy as np
from pydantic import BaseModel

class Input(BaseModel):
    numbers: list[int]

def lambda_handler(event, context):
    """
    Lambda handler, see https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html
    """
    input: Input = event

    a = np.array(input.numbers)

    b = a.unique()

    response = {
        "unique": b,
        "time_left": f'{context.get_remaining_time_in_millis()/100}',
        "function_name": f'{context.function_name}'
    }
    print(response)
    return response