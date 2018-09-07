terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }
}


app_name = "es-cluster"

instance_type = "t2.medium"

ebs_device_volume_size = "1024"

policy_file = "ec2_policy.json"

role_policy_file = "policies/ec2_role_policy.json"

elasticsearch_root_directory = "/srv"

ebs_device_mount_point = "/dev/xvdb"

docker_registry_url = "mojdigitalstudio"

docker_image_tag = "latest"
