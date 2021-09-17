#!/usr/bin/python
'''
This script finds an instance by its ID.
Then, it finds out its public IP address and changes Route53 'A' record.
'''

import boto3

def find_ip(id):
    '''
    Finds a public IP address based on instance ID.
    Returns a public IP address.
    '''
    ec2 = boto3.resource('ec2')
    instance = ec2.Instance(id)
    ip = instance.public_ip_address
    return ip

def change_route53_record(zone_id, domain, ip):
    '''
    Changes Route53 type A record.
    '''
    r53 = boto3.client('route53')
    r53.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch={
            'Comment': 'test',
            'Changes': [
                {
                    'Action': 'UPSERT',
                    'ResourceRecordSet': {
                        'Name': domain,
                        'ResourceRecords': [
                            {
                                'Value': ip
                            }
                        ],
                    'Type': 'A',
                    'TTL': 300
                    }
                },
            ]
        }
    )
    
# set instance ID
instance_id = '' # Instance ID, e.g. 'i-0111112233'
# set Hosted Zone ID
zone_id = '' # Hosted Zone ID, e.g. 'ZBDAAABBBCCC'
# domain
domain = '' # Domain, e.g. technoff.eu

# find the public IP address
ip_address = find_ip(instance_id)
# change 'A' record
change_a_record = change_route53_record(zone_id, domain, ip_address)
print(domain + ' record was changed to: ' + ip_address)