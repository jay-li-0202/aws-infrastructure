# AWS Infrastructure

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
```
