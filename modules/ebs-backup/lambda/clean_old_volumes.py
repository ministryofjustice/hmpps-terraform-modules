import boto3
import datetime
from datetime import datetime
import ConfigParser

config = ConfigParser.RawConfigParser()
config.read('./vars.ini')


def lambda_handler(event, context):
    regions = config.get('regions', 'regionList')
    region_list = regions.split(',')
    account_id = str(context.invoked_function_arn.split(":")[4])

    for region in region_list:
        print("Pruning old volumes in {}".format(region))
        aws_region = region
        ec = boto3.client('ec2', region_name=aws_region)

        for snapshot in ec.describe_snapshots(
                OwnerIds=[
                    account_id
                ],
                MaxResults=1000,
                Filters=[
                    {
                        'Name': 'tag-key',
                        'Values': [
                            'DeleteOn',
                        ]
                    }
                ]
                )['Snapshots']:

            if 'Tags' in snapshot:
                print("Checking snapshot {}".format(snapshot["SnapshotId"]))
                for tags in snapshot['Tags']:
                    if tags["Key"] == 'DeleteOn':
                        if datetime.strptime(tags["Value"], "%Y-%m-%d").date() < datetime.today().date():
                            print("Snapshot {} has expired on date {}".format(snapshot["SnapshotId"], tags["Value"]))
                            result = ec.delete_snapshot(
                                SnapshotId=snapshot["SnapshotId"]
                            )
                            if result["ResponseMetadata"]["HTTPStatusCode"] == 200:
                                print("Snapshot {} deleted successfully".format(snapshot["SnapshotId"]))
                            else:
                                print("Snapshot {} deletion failed".format(snapshot["SnapshotId"]))
                        else:
                            print("Shapshot {} is still valid for retention".format(snapshot["SnapshotId"]))

