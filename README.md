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
