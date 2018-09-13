terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../../vpc", "../ecr"]
  }
}

app_name = "nginx"

alb_http_port = "80"

alb_https_port = "443"

internet_zone_label = "public"

# LB SETTINGS
alb_backend_port = "443"

alb_http_port = "80"

deregistration_delay = "90"

backend_app_port = "80"

backend_app_protocol = "HTTP"

backend_app_template_file = "template.json"

backend_check_app_path = "/"

backend_check_interval = "120"

backend_ecs_cpu_units = "256"

backend_ecs_desired_count = "1"

backend_ecs_memory = "2048"

backend_healthy_threshold = "2"

backend_maxConnections = "500"

backend_maxConnectionsPerRoute = "200"

backend_return_code = "200"

backend_timeout = "60"

backend_timeoutInSeconds = "60"

backend_timeoutRetries = "10"

backend_unhealthy_threshold = "10"

target_type = "instance"

# ASG
service_desired_count = "2"

user_data = "user_data/user_data.sh"

volume_size = "20"

ebs_device_name = "/dev/xvdb"

ebs_volume_type = "standard"

ebs_volume_size = "10"

ebs_encrypted = "true"

instance_type = "t2.medium"

asg_desired = "2"

asg_max = "2"

asg_min = "2"

associate_public_ip_address = true

keys_dir = "/opt/keys"

# ECS 

image_url = "mojdigitalstudio/hmpps-nginx-non-confd"

version = "latest"
