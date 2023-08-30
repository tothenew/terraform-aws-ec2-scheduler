import boto3
import os

def lambda_handler(event, context):

    region = os.environ.get('region')
    ec2 = boto3.resource('ec2', region_name=region)

    # Get the tag key and value from environment variables
    tag_key = os.environ.get('tag_key')
    tag_value = os.environ.get('tag_value')

    filters = [
        {
            'Name': f'tag:{tag_key}',
            'Values': [tag_value]
        },
        {
            'Name': 'instance-state-name',
            'Values': ['stopped']
        }
    ]

    # Filter stopped instances that should start
    instances = ec2.instances.filter(Filters=filters)

    # Retrieve instance IDs
    instance_ids = [instance.id for instance in instances]

    # Starting instances
    starting_instances = ec2.instances.filter(
        Filters=[{'Name': 'instance-id', 'Values': instance_ids}]
    ).start()
