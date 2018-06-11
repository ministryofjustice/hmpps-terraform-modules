remote state terraform module
===========

---

A terraform module to provide a remote state bucket in AWS.


Module Input Variables
----------------------

- `remote_state_bucket_name` - name to be used for the bucket

- `kms_key_arn` - kms key used to encrypt bucket

- `tags` - tags map used to tag resources

Usage
-----

```hcl

module "remote_state" {
  source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//remote_state"
  remote_state_bucket_name = "my-remote-state-bucket"
  kms_key_arn              = "kms-key-arn"
  tags                     = availability_zone = {
    owner = "my-name"
    project = "eu-west-2b"
    az = "eu-west-2c"
    }
}
```

Outputs
=======

- `s3_bucket_id` - id of the created remote state bucket