import boto3
ec2 = boto3.resource('ec2')

# create a new EC2 instance
instances = ec2.create_instances(
     ImageId='ami-09e67e426f25ce0d7', # ubuntu  ami id
     MinCount=1,
     MaxCount=1,
     InstanceType='t2.micro',
     KeyName='guile' #yourkeypair without .pem
 )
