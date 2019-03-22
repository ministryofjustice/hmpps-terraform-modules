import boto3
import configparser
import datetime

config = configparser.RawConfigParser()
config.read('./vars.ini')


def lambda_handler(event, context):
    regions = config.get('regions', 'regionList')
    region_list = regions.split(',')
    retention_days = config.getint('main', 'retention_days')

    for r in region_list:
        aws_region = r
        print("Checking Region %s" % aws_region)

        ec = boto3.client('ec2', region_name=aws_region)
        volumes = ec.describe_volumes()['Volumes']

        for volume in volumes:
            if 'Attachments' in volume:
                backup_device = False
                instance_name = 'Unknown'

                vol_id = volume['VolumeId']
                try:
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
                                    {'Key': 'DeviceName', 'Value': device_name},
                                    {'Key': 'Source', 'Value': 'Automated Volume Snapshot'},
                                    {'Key': 'InstanceName', 'Value': instance_name}
                                ]
                            )
                except IndexError:
                    pass
