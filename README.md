# AWS Infrastructure

## Goal

> Easily provision an AWS environment required to run our applications.

## Getting started

This guide assumes you are using [fish](https://fishshell.com/) as a shell.

We will be building two environments, one for production and one for staging. Start off by cloning this in separate directories for each environment.

```bash
git clone git clone git@github.com:informatievlaanderen/aws-infrastructure.git vbr-staging
git clone git clone git@github.com:informatievlaanderen/aws-infrastructure.git vbr-production
```

We will also be using named AWS Profiles for your environments which you can create using:

```bash
aws configure --profile vbr-staging
aws configure --profile vbr-production
```

If you have previously executed commands, you should re-initialize terraform by running the following commands prefixed with `ENVIRONMENT=vbr-staging` or `ENVIRONMENT=vbr-production`:

```bash
env ENVIRONMENT=... make init
```

## Create a Terraform Remote State Bucket and bootstrap your account

We are going to use an S3 bucket _in the same
account_ for storing Terraform state. There is no reason this has to be the
case - you could put it in a separate account, or, better, on a separate
hosting provider.

Although we will use Terraform to create the remote state bucket, the state
used for the composition root which creates it will not be managed with remote
state, since a chicken-and-egg problem exists. Instead, we will abandon this
state - also protecting against rogue accidental
`terraform destroy` operations which could be catastrophic for future
management.

Create a set of root credentials for an empty AWS account. These will be
used to execute the Terraform which creates the remote state bucket, as well as
in the next step to enable CloudTrail, create a password policy, and create
some buckets for logs, bootstrap TLS keys and to create a user from which all
other Terraform will be executed (likely the set handed to your CI system).

First, edit `vbr-staging.tfvars` and `vbr-production.tfvars` with a unique bucket name for state. These
must be globally unique! Afterwards, update `vbr-staging-backend.tfvars` and `vbr-production-backend.tfvars` as well.

Then, run the following commands prefixed with `ENVIRONMENT=vbr-staging` or `ENVIRONMENT=vbr-production`:

```bash
environment/
env ENVIRONMENT=... make state-bootstrap
env ENVIRONMENT=... ACTION=apply make state-bootstrap

env ENVIRONMENT=... make account-bootstrap
env ENVIRONMENT=... ACTION=apply make account-bootstrap
```

Following this, update your Named AWS Profiles to use the credentials created in the previous step (`tf_user_key`, `tf_user_secret` and `tf_user_name`) for the Terraform account from hereon in.

```bash
aws configure --profile vbr-staging
aws configure --profile vbr-production
```

## Build a VPC

The VPC composition root creates a VPC following all known AWS best practices -
public and private subnets distributed over three availability zones, a VPC
endpoint for S3, NAT and Internet gateways with appropriate routing tables for
each subnet. Flow logs are also enabled, along with a DHCP options set
customizing the domain name assigned to new instances.

Customise the address space in the `vbr-staging.tfvars` and `vbr-production.tfvars` files, and then run the following commands:

```bash
environment/
env ENVIRONMENT=... make base-vpc
env ENVIRONMENT=... ACTION=apply make base-vpc
```

## Build Route 53 Zones

To easily manage our DNS records, we use a public and private Route 53 zone.
To setup these zones, run the following commands:

```bash
environment/
env ENVIRONMENT=... make dns
env ENVIRONMENT=... ACTION=apply make dns
```

At this moment, you can configure your public domain name to use the new nameservers.

## Build a Docker Repository

All our work will be running on Docker, in orde to host our images, we will use
`Amazon Elastic Container Registry`. To setup, run the following commands:

```bash
environment/
env ENVIRONMENT=... make docker-repo
env ENVIRONMENT=... ACTION=apply make docker-repo
```

## Build a Fargate cluster

Our workload will run as Docker containers on a Fargate (ECS) cluster. To setup, run the following commands:

```bash
environment/
env ENVIRONMENT=... make fargate
env ENVIRONMENT=... ACTION=apply make fargate
```

## Build the infrastructure for Datadog monitoring

We monitor using Datadog, which [requires some AWS setup](https://docs.datadoghq.com/integrations/amazon_web_services/?tab=allpermissions#installation) to work.

You will need [an API key](https://app.datadoghq.com/account/settings#api) and [an external id](https://app.datadoghq.com/account/settings#integrations/amazon_web_services) for this.

To setup, run the following commands:

```bash
environment/
env ENVIRONMENT=... make monitoring
env ENVIRONMENT=... ACTION=apply make monitoring
```

Copy the `datadog_lambda_arn` output to the `Collect Logs` tab on the [Amazon Web Services Integration tile in Datadog](https://app.datadoghq.com/account/settings#integrations/amazon_web_services).

## Build the infrastructure for a Bastion Host

We create a base Docker image to use as a bastion host to connect to resources on our private VPC.

Allowed public SSH keys are present in [authorized_keys](https://github.com/Informatievlaanderen/aws-infrastructure/blob/master/machines/bastion/authorized_keys).

This image is stored in Docker Hub, to build the image, run the following commands, make sure to configure `DOCKERHUB_USER` and `DOCKERHUB_PASS` to be able to push to Docker Hub:

```bash
images/
env ENVIRONMENT=... DOCKERHUB_REPOSITORY=basisregisters DOCKERHUB_USER=... DOCKERHUB_PASS=... make bastion
env ENVIRONMENT=... DOCKERHUB_REPOSITORY=basisregisters DOCKERHUB_USER=... DOCKERHUB_PASS=... ACTION=build make bastion
```

## Using Bastions

Starting a bastion is done through an API call which triggers a Lamba function to start a task running an SSH daemon.

You can configure additional users in [environment/roots/bastions/main.tf](https://github.com/Informatievlaanderen/aws-infrastructure/blob/master/environment/roots/bastions/main.tf).

To setup, run the following commands:

```bash
environment/
env ENVIRONMENT=... make bastions
env ENVIRONMENT=... ACTION=apply make bastions
```

The API endpoint is output as `bastion_api_endpoint`, together with `bastion_api_key`. Together these allow you to start a bastion with:

```bash
curl -X POST -H "X-Api-Key: abcdefghi....xyz" "https://abcdefg.execute-api.eu-west-1.amazonaws.com/bastions-production/bastion?user=cumpsd"
```

Which will start a bastion and return it's IP:

```json
{
  "ip": "54.123.123.123",
  "status": "created"
}
```

To delete it, you can run:

```bash
curl -X DELETE -H "X-Api-Key: abcdefghi....xyz" "https://abcdefg.execute-api.eu-west-1.amazonaws.com/bastions-production/bastion?user=cumpsd"
```

## Build an Elasticsearch cluster

For searching we use Elasticsearch, running in a cluster. To setup, run the following commands:

```bash
environment/
env ENVIRONMENT=... make elasticsearch
env ENVIRONMENT=... ACTION=apply make elasticsearch
```

## Build an ElastiCache cluster

For caching we use ElastiCache with Redis. To setup, run the following commands:

```bash
environment/
env ENVIRONMENT=... make cache
env ENVIRONMENT=... ACTION=apply make cache
```

## Build a SQL Server instance

For storage we use SQL Server. To setup, run the following commands and input a dbo username and password to use when prompted:

```bash
environment/
env ENVIRONMENT=... make sqlserver
env ENVIRONMENT=... ACTION=apply make sqlserver
```

## Build the infrastructure for a Build Server Agent

We create a base Docker image to use as a build agent for our project.

You can have a look at the image definition and perhaps edit it to only include the .NET Core versions you need: [build-agent.json](https://github.com/Informatievlaanderen/aws-infrastructure/blob/master/machines/build-agent/build-agent.json)

This image is stored in Docker Hub, to build the image, run the following commands, make sure to configure `DOCKERHUB_USER` and `DOCKERHUB_PASS` to be able to push to Docker Hub:

```bash
machines/
env ENVIRONMENT=... DOCKERHUB_REPOSITORY=basisregisters DOCKERHUB_USER=... DOCKERHUB_PASS=... make build-agent
env ENVIRONMENT=... DOCKERHUB_REPOSITORY=basisregisters DOCKERHUB_USER=... DOCKERHUB_PASS=... ACTION=build make build-agent
```

## Deploy Base Registries

This is specific for our project. It deploys our entire application.

Make sure you have a Bastion host up and running and port mapped the internal-only resources:

```bash
ssh -i <your_private_key.pem> \
    -L 9000:es.staging-basisregisters.local:443 \
    -L 9001:db.staging-basisregisters.local:1433 \
    -L 6379:cache.staging-basisregisters.local:6379 \
    root@<bastion_ip>
```

Afterwards you can deploy by running the following commands and answering the prompts for passwords and users when asked:

```bash
applications/
env ENVIRONMENT=... make basisregisters
env ENVIRONMENT=... ACTION=apply make basisregisters
```

## Credits

### Tools

* [Terraform](https://github.com/hashicorp/terraform/blob/master/LICENSE) - _Terraform is a tool for building, changing, and combining infrastructure safely and efficiently._ - [MPL-2.0](https://choosealicense.com/licenses/mpl-2.0/)
* [Packer](https://github.com/hashicorp/packer/blob/master/LICENSE) - _Packer is a tool for creating identical machine images for multiple platforms from a single source configuration._ - [MPL-2.0](https://choosealicense.com/licenses/mpl-2.0/)
* [Ansible](https://github.com/ansible/ansible/blob/devel/COPYING) - _Ansible is a radically simple IT automation platform that makes your applications and systems easier to deploy._ - [GPL-3.0](https://choosealicense.com/licenses/gpl-3.0/)
* [Fargate](https://github.com/jpignata/fargate/blob/master/LICENSE) - _CLI for AWS Fargate._ - [Apache-2.0](https://choosealicense.com/licenses/apache-2.0/)

### Ansible Roles

* [ansible-docker](https://github.com/geerlingguy/ansible-role-docker/blob/master/LICENSE) - _Ansible Role - Docker._ - [MIT](https://choosealicense.com/licenses/mit/)
* [ansible-role-dotnet-core](https://github.com/ocha/ansible-role-dotnet-core/blob/master/LICENSE) - _Ansible Role - .NET Core for Ubuntu/RHEL/CentOS._ - [MIT](https://choosealicense.com/licenses/mit/)
* [ansible-latest-git](https://github.com/Oefenweb/ansible-latest-git/blob/master/LICENSE.txt) - _Ansible role to set up the latest version of git in Ubuntu systems._ - [MIT](https://choosealicense.com/licenses/mit/)
* [ansible-locales](https://github.com/Oefenweb/ansible-locales/blob/master/LICENSE.txt) - _Ansible role to set up locales in Debian-like systems._ - [MIT](https://choosealicense.com/licenses/mit/)
* [ansible-role-nodejs](https://github.com/geerlingguy/ansible-role-nodejs/blob/master/LICENSE) - _Ansible Role - Node.js_ - [MIT](https://choosealicense.com/licenses/mit/)
* [ansible-pip](https://github.com/Oefenweb/ansible-pip/blob/master/LICENSE.txt) - _Ansible role to set up (the latest version of) pip, wheel and setuptools in Debian-like systems._ - [MIT](https://choosealicense.com/licenses/mit/)
