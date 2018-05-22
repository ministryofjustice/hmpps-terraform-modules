# hmpps-terraform-modules
Terraform modules for hmpps-aws-migration

TERRAGRUNT
===========

## DOCKER CONTAINER IMAGE

Container repo [hmpps-engineering-tools](https://github.com/ministryofjustice/hmpps-engineering-tools)

To run the container please run the following steps

#### ARN FOR NON PROD ENGINEERING

```
arn:aws:iam::895523100917:role/terraform
```

#### TERRAFORM REPOS

[hmpps-engineering-platform-terraform](https://github.com/ministryofjustice/hmpps-engineering-platform-terraform)

[hmpps-terraform-modules](https://github.com/ministryofjustice/hmpps-terraform-modules)

Ensure both repos above are cloned into the current directory

```
ls
hmpps-engineering-platform-terraform	hmpps-terraform-modules

```

#### START UP

Provide the docker coantainer with the following environment variables

```
TERRAGRUNT_IAM_ROLE
AWS_PROFILE
```

#### COMMAND


```
docker run -it --rm -v $(pwd):/home/tools/data \
	-v ~/.aws:/home/tools/.aws \
	-e TERRAGRUNT_IAM_ROLE="arn:aws:iam::895523100917:role/terraform" \
	-e AWS_PROFILE=hmpps-token \
	hmpps-terraform-builder:latest \
	bash
```