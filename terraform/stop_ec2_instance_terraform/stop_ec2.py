import boto3
import argparse

parser = argparse.ArgumentParser(description='Delete AWS EC2 snapshots older than a specified date with a specific tag.')
parser.add_argument('instance_id', type=str, help='The instance ID to start')
parser.add_argument('region', type=str, default='us-east-1', help='The AWS region to use (default: us-east-1)')
args = parser.parse_args()

ec2 = boto3.client('ec2',region_name=args.region)
ec2.stop_instances(InstanceIds=[args.instance_id])
print('Instance stoped')