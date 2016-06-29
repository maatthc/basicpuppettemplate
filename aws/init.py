#!/usr/bin/env perl
import sys

import time

try:
    import boto3
except Exception as e:
    print("Install Boto module: pip install boto3 ")
    sys.exit(1)
# Fix Python 2.x.
try:
    input = raw_input
except NameError:
    pass

region = 'ap-southeast-2'
template_file="Sinatra_Nginx-CloudFormation.template.json"
mystack = 'SinatraWebStack'

print("===== AWS Authentication =======\n")
print("===> Please create credentials specifically to run this test!!! ")
print("  Your local ACCESS_KEY WON'T be used unless you entry it again now: ")
access_key = raw_input("  Enter your ACCESS_KEY: ")
secret_key = raw_input("  Enter your SECRET_KEY: ")

session = boto3.Session(
    aws_access_key_id=access_key,
    aws_secret_access_key=secret_key,
    region_name=region
)

print("-----------------\n\nCreating temporary Key Pair..")
ec2 = session.resource('ec2')
try:
    keypair = ec2.create_key_pair(KeyName='SinatraAppTest')
    print("In case you would like to login into the EC2 instances that will be created, please use this Private key: ")
    print(keypair.key_material)
except Exception as e:
    print("Error creating KeyPair: " + str(e))

print("\n\nReading CloudFormation Template..")
with open(template_file, 'r') as infile:
    template=infile.read()
print("Done..")

client = session.resource('cloudformation')
response = client.create_stack(StackName=mystack,
    TemplateBody=template,
    Parameters=[
        {
        'ParameterKey': 'KeyName',
        'ParameterValue': 'SinatraAppTest',
        'UsePreviousValue': False
        },
        {
            'ParameterKey': 'WebServerCapacity',
            'ParameterValue': '2',
            'UsePreviousValue': False
        }
        ],
    NotificationARNs=[],
    DisableRollback=False,
    TimeoutInMinutes=120,
    Capabilities=[])
print("\n\n--------------------------------")
stack_created = False
print("Waiting the Stack to be deployed.. \n")
while not stack_created:
    stack = client.Stack(mystack)
    if stack.outputs:
        print("\n\n--------------------------------\n\nThis is the URL of the Sinatra Website : ")
        print(stack.outputs[0]['OutputValue'])
        print("\n\n--------------------------------")
        break
    sys.stdout.write('.')
    sys.stdout.flush()
    time.sleep(5)