**Table of Contents**  

- [Before you start](#before-you-start)
- [Vagrant](#vagrant)
        - [Description](#description)
        - [Objective](#objective)
        - [Target OS](#target-os)
        - [How to start](#how-to-start)
        - [Outcome](#outcome)
- [Amazon CloudFormation](#amazon-cloudformation)
        - [Description](#description-1)
        - [Objective](#objective-1)
        - [Target OS](#target-os-1)
        - [Pre-requisites](#pre-requisites)
        - [How to start](#how-to-start-1)
        - [Outcome](#outcome-1)
- [Google Cloud Container Engine](#google-cloud-container-engine)
        - [Description](#description-2)
        - [Objective](#objective-2)
        - [Target OS](#target-os-2)
        - [Pre-requisites](#pre-requisites-1)
        - [How to start](#how-to-start-2)
        - [Outcome](#outcome-2)

The objective of this exercise is to implement the requirement of [REA Simple Sinatra App](https://github.com/rea-cruitment/simple-sinatra-app).
Three different strategies were used to deliver the solution:
- Vagrant + Puppet : To be used locally with VMs (or also baremetal servers)
- Amazon CloudFormation : To demostrate how to setup the environment using AWS
- Google Cloud Container Engine : To demostrate how to use Docker and Kuberntes

# Before you start
First of all you need a Git client installed and properly configured. 
You also need to clone this repository to your workstation, for example to the folder "/tmp/rea":

```
git clone https://github.com/maatthc/rea.git /tmp/rea
```

Althought all development was done using a MacBookPro workstation, the code here presented might be also compatible with a Linux workstation with some ajustments. 

# Vagrant
## Description
This implemention makes use of Vagrant and VirtualBox to setup a complete Puppet deployment, with a Master and two agents, each one with a different Linux distro. 
The Master will be setup and a specific Puppet module will be deployed (rea) - This module defines the manifest/hiera data what will be used to setup the Agents.
The Agents then will be created, connect do the Master and apply the manifests required to deploys the Sinatra App - each one uses different techniques to support the Application, according with its Linux distro (CentOS and Ubuntu). 
The VMs will be bootstrapped using one unique provisioning script (provision.sh), that will install the basic packages and setup things like name resolution.
## Objective
The objective is to demostrate the traditional Infrastructure as Code (IaC) approach using  Automation Tools as Puppet.
## Target OS
 - CentOS 7
 - Ubuntu 16.04
## Pre-requisites
You will need [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) installed and properly configured. 

## How to start
From you cloned repository folder, go to the "vagrant" folder:
```
cd /tmp/rea/vagrant
```

Start the Master instance:
```
vagrant up master_centos   
```

Wait until the end of the previous command and then spin up the two Agents:
```
vagrant up webserver_centos 
vagrant up webserver_ubuntu
```
## Outcome
The process of spinning up the Agents and applying all the states might take around 10 minutes. After that you will able the acess the Sinatra App running on each VM using the links bellow:
- CentOS: [http://10.0.1.51/](http://10.0.1.51/)
- Ubuntu: [http://10.0.1.52/](http://10.0.1.52/)

# Amazon CloudFormation
## Description
This implemention makes use of a single CloudFormation template to define some EC2 instances and the ElasticLoadBalancer, SecurityGroups and AutoScaling polices that defines the Infrastructre. 
The same Template also defines the Nginx, Supervisord and Unicorn services that will used to support the Application.
## Objective
Present a alternative Infrastructure as Code (IaC) approach, using entirely the Amazon AWS Stack. 
## Target OS
 - Amazon Linux AMI

## Pre-requisites
- Valid AWS credentials Access Key ID/Secret Access Key - Please create one isolated from your production credentials.
- Python version 2.7 or superior installed on your workstation.
- Python module boto3 installed: pip install boto3 .

## How to start
From you cloned repository folder, go to the "aws" folder:
```
cd /tmp/rea/aws
```
Run the Boto Python Script - It will create its own EC2 Key Pair for the Sydney Region, load the Json Template, trigger the Stack creating and wait it to be deployed.
```
python init.py
```
## Outcome
After around 5 minutes the script will print the URL for the Sinatra WebApp, what will be running in two EC2 instances with Auto Scaling and load balance.

# Google Cloud Container Engine
## Description
This implemention utilizes the Google implementation of Kubernetes, Docker and microcontainers.
## Objective
This approach abstract the infrastructure completely, focousing only on encapsuling the application code in a microcontainer and deploying it on top of Container Cluster Provider.
## Target OS
- [Alpine Linux](http://www.alpinelinux.org/)

## Pre-requisites
 - [Google Cloud Platform account](http://console.cloud.google.com/)
 - A test Google Cloud Platform Project with any name
 - [Docker](https://docs.docker.com/engine/installation/), [Google Cloud SDK](https://cloud.google.com/sdk/) and [kubectl](http://kubernetes.io/docs/user-guide/kubectl-overview/) installed.
 - [Google Cloud SDK](https://cloud.google.com/sdk/) initialized and configured to use your Test Project: gcloud init

## How to start
From you cloned repository folder, go to the "googlecloud" folder:
```
cd /tmp/rea/googlecloud
```
Execute the init script - It will build the Docker image, pull it the Google Cloud Container Registry, create the cluster/pods and expose it publicly to the Internet. 
```
sh init.sh
```
## Outcome
The last step will inform you the Public IP that can be used to access your application on the cluster - Use the field 'EXTERNAL-IP' as :

_http://EXTERNAL-IP/_
