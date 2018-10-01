#!/usr/bin/env bash

yum install -y python-pip git

cat << EOF >> /etc/environment
HMPPS_ROLE=${app_name}
HMPPS_FQDN=monitoring.${private_domain}
HMPPS_STACKNAME=${env_identifier}
HMPPS_STACK="${short_env_identifier}"
HMPPS_ENVIRONMENT=${route53_sub_domain}
HMPPS_ACCOUNT_ID="${account_id}"
HMPPS_DOMAIN="${private_domain}"
EOF
## Ansible runs in the same shell that has just set the env vars for future logins so it has no knowledge of the vars we've
## just configured, so lets export them
export HMPPS_ROLE="${app_name}"
export HMPPS_FQDN="monitoring.${private_domain}"
export HMPPS_STACKNAME="${env_identifier}"
export HMPPS_STACK="${short_env_identifier}"
export HMPPS_ENVIRONMENT=${route53_sub_domain}
export HMPPS_ACCOUNT_ID="${account_id}"
export HMPPS_DOMAIN="${private_domain}"

cd ~
pip install ansible

cat << EOF > ~/requirements.yml
- name: bootstrap
  src: https://github.com/ministryofjustice/hmpps-bootstrap
- name: rsyslog
  src: https://github.com/ministryofjustice/hmpps-rsyslog-role
- name: elasticbeats
  src: https://github.com/ministryofjustice/hmpps-beats-monitoring
- name: users
  src: singleplatform-eng.users
EOF

cat << EOF > ~/bootstrap_vars.yml
mount_point: "${es_home}"
device_name: "${ebs_device}"
monitoring_host: "monitoring.${private_domain}"
EOF

wget https://raw.githubusercontent.com/ministryofjustice/hmpps-delius-ansible/master/group_vars/bastion -O bastion.yml
# We need the ec2-user still for now for this to function correctly
sed "/- username: ec2-user/d" bastion.yml > users.yml
rm bastion.yml

cat << EOF > ~/bootstrap.yml
---

- hosts: localhost
  vars_files:
    - "{{ playbook_dir }}/bootstrap_vars.yml"
    - "{{ playbook_dir }}/users.yml"
  roles:
     - bootstrap
     - rsyslog
     - elasticbeats
     - users
EOF


ansible-galaxy install -f -r ~/requirements.yml
IS_MONITORING=True HAS_DOCKER=True ansible-playbook ~/bootstrap.yml
 HAS_DOCKER=True ansible-playbook ~/bootstrap.yml -e mount_point="${es_home}" -e device_name="${ebs_device}" -e monitoring_host="monitoring.${private_domain}"

#Create docker-compose file and env file
mkdir -p ${es_home}/service-monitoring ${es_home}/elasticsearch/data ${es_home}/elasticsearch/conf.d

cat << EOF > ${es_home}/service-monitoring/docker-compose.yml
version: "3"

services:
  elasticsearch:
    image: ${registry_url}/hmpps-elasticsearch:${version}
    volumes:
      - ${es_home}/elasticsearch/data:/usr/share/elasticsearch/data
      - ${es_home}/elasticsearch/conf.d:/usr/share/elasticsearch/conf.d
    environment:
      - HMPPS_ES_CLUSTER_NAME=${aws_cluster}
      - HMPPS_ES_NODE_NAME=${app_name}
      - HMPPS_ES_NODE_TYPE=ingest
      - HMPPS_ES_CLUSTER_NODES_01=elasticsearch-1.${private_domain}
      - HMPPS_ES_CLUSTER_NODES_02=elasticsearch-2.${private_domain}
      - HMPPS_ES_CLUSTER_NODES_03=elasticsearch-3.${private_domain}
      - HMPPS_ES_NETWORK_PUBLISH_HOST=`curl http://169.254.169.254/latest/meta-data/local-ipv4/`
    ports:
      - 9300:9300
      - 9200:9200
    ulimits:
      nofile: 65536

  kibana:
    image: ${registry_url}/hmpps-kibana:${version}
    environment:
      - HMPPS_KIBANA_SERVER_NAME=${short_env_identifier}-kibana
      - HMPPS_KIBANA_SERVER_HOST=0.0.0.0
    ports:
      - 5601:5601
    depends_on:
      - elasticsearch
    ulimits:
      nofile: 65536

  logstash:
    image: ${registry_url}/hmpps-logstash:${version}
    ports:
      - 2514:2514
      - 9600:9600
    environment:
      - LOGSTASH_OUTPUT_ELASTICSEARCH=yes
    depends_on:
      - redis

  redis:
    image: redis:4-alpine
    ports:
      - 6379:6379
EOF

chown -R 1000:1000 ${es_home}/elasticsearch
chmod -R 777 ${es_home}/elasticsearch
ulimit -n 65536
sysctl -w vm.max_map_count=262144
docker-compose -f ${es_home}/service-monitoring/docker-compose.yml up -d