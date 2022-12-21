### To determine if there are any unattached (unused) Amazon EBS volumes available in your AWS account
```
aws ec2 describe-volumes --region us-east-1 --query 'Volumes[*].VolumeId'
```

```
aws ec2 describe-volumes --region us-east-1 --volume-ids vol-0c730ea526910dfc9 --query 'Volumes[*].state'
```

### This will list only unencrypted volumes and will display the VolumeId and the value of the application tag:

```
aws ec2 describe-volumes --filters Name=encrypted,Values=false --query 'Volumes[].[VolumeId,Tags[?Key==`application`]|[0].Value]' --output text

```

### To describe volumes that are attached to a specific instance

```
aws ec2 describe-volumes \
    --region us-east-1 \
    --filters Name=attachment.instance-id,Values= i-0be257d9be3a4993f Name=attachment.delete-on-termination,Values=true
```