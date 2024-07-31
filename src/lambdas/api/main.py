import boto3
import os
import uuid
from urllib.parse import unquote_plus
from PIL import Image

s3_client = boto3.client('s3')

def resize_image(image_path, resized_path):
    with Image.open(image_path) as image:
        image.thumbnail(tuple(x / 2 for x in image.size))
        image.save(resized_path)
        print(f'image resized')

def lambda_handler(event, context):
    print(f'Event received {event['Records'][0]['s3']['bucket']['name']}')
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        print(f'bucket: {bucket}')
        print(f'quoted key: {record['s3']['object']['key']}')
        key = unquote_plus(record['s3']['object']['key'])
        print(f'key: {key}')
        tmpkey = key.replace('/', '')
        download_path = f'/tmp/{uuid.uuid4()}-{tmpkey}'
        print(f'download_path: {download_path}')
        upload_path = f'/tmp/resized-{tmpkey}'

        try:
            s3_client.download_file(bucket, key, download_path)
        except Exception as e:
            print('Error!')
            print(e)

        print(f'file downloaded...')
        if os.path.exists(download_path):
            resize_image(download_path, upload_path)
            s3_client.upload_file(upload_path, 'archive-image-store', f'resized-{key}')
        else:
            print(f'File {download_path} doesnt exist!')

        print(f'finished....')

