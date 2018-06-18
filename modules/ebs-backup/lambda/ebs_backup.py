import boto3
import ConfigParser
import botocore
import datetime
import re
import collections

config = ConfigParser.RawConfigParser()
config.read('./vars.ini')


def lambda_handler(event, context):
    regions = config.get('regions', 'regionList')
    region_list = regions.split(',')
    instance_tag = config.get('main', 'ec2_instance_tag')
    retention_days = config.getint('main', 'retention_days')

    for r in region_list:
        aws_region = r
        print("Checking Region %s" % aws_region)
        account = event['account']
        ec = boto3.client('ec2', region_name=aws_region)
        volumes = ec.describe_volumes()['Volumes']

        for volume in volumes:
            if 'Attachments' in volume:
                backup_device = False
                instance_name = 'Unknown'

                vol_id = volume['VolumeId']
                instance_id = volume['Attachments'][0]['InstanceId']
                device_name = volume['Attachments'][0]['Device']

                if 'Tags' in volume:
                    for tags in volume['Tags']:
                        if tags["Key"] == 'Name':
                            instance_name = tags["Value"]
                        if tags["Key"] == 'CreateSnapshot':
                            backup_device = True

                    if backup_device:
                        print("Found EBS Volume %s on Instance %s, creating Snapshot" % (vol_id, instance_id))
                        snap = ec.create_snapshot(
                            Description="Snapshot of Instance %s (%s) %s" % (instance_id, instance_name, device_name),
                            VolumeId=vol_id,
                        )
                        snapshot = "%s_%s" % (snap['Description'], str(datetime.date.today()))
                        delete_date = datetime.date.today() + datetime.timedelta(days=retention_days)
                        delete_fmt = delete_date.strftime('%Y-%m-%d')
                        ec.create_tags(
                            Resources=[snap['SnapshotId']],
                            Tags=[
                                {'Key': 'DeleteOn', 'Value': delete_fmt},
                                {'Key': 'Name', 'Value': snapshot},
                                {'Key': 'InstanceId', 'Value': instance_id},
                                {'Key': 'DeviceName', 'Value': device_name}
                            ]
                        )

        delete_on = datetime.date.today().strftime('%Y-%m-%d')
        filters = [
            {'Name': 'tag-key', 'Values': ['DeleteOn']},
            {'Name': 'tag-value', 'Values': [delete_on]},
        ]
        snapshot_response = ec.describe_snapshots(
            OwnerIds=['%s' % account],
            Filters=filters
        )
        for snap in snapshot_response['Snapshots']:
            print "Deleting snapshot %s" % snap['SnapshotId']
            ec.delete_snapshot(SnapshotId=snap['SnapshotId'])
