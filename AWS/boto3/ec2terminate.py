import boto3
ec2 = boto3.resource('ec2')
ec2.Instance('i-0ab0bd443fd9c611d').terminate() # put your instance id
