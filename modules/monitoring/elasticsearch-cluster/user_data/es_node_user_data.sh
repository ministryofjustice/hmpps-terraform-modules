#!/usr/bin/env bash

yum install -y python-pip git

cat << EOF >> /etc/environment
HMPPS_ROLE=${app_name}
HMPPS_FQDN=elasticsearch-${instance_identifier}.${private_domain}
HMPPS_STACKNAME=${env_identifier}
HMPPS_STACK="${short_env_identifier}"
HMPPS_ENVIRONMENT=${route53_sub_domain}
HMPPS_ACCOUNT_ID="${account_id}"
HMPPS_DOMAIN="${private_domain}"
EOF

## Ansible runs in the same shell that has just set the env vars for future logins so it has no knowledge of the vars we've
## just configured, so lets export them
export HMPPS_ROLE="${app_name}"
export HMPPS_FQDN="elasticsearch-${instance_identifier}.${private_domain}"
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
  version: centos
- name: rsyslog
  src: https://github.com/ministryofjustice/hmpps-rsyslog-role
- name: elasticbeats
  src: https://github.com/ministryofjustice/hmpps-beats-monitoring
EOF

cat << EOF > ~/bootstrap.yml
---

- hosts: localhost
  roles:
     - bootstrap
     - rsyslog
     - elasticbeats

EOF

ansible-galaxy install -f -r ~/requirements.yml
HAS_DOCKER=True ansible-playbook ~/bootstrap.yml -e mount_point="${es_home}" -e device_name="${ebs_device}" -e monitoring_host="monitoring.${private_domain}"

#Create docker-compose file and env file
mkdir -p ${es_home}/service-elasticsearch ${es_home}/elasticsearch/data ${es_home}/elasticsearch/conf.d

cat << EOF > ${es_home}/service-elasticsearch/docker-compose.yml
version: "3"

services:
  elasticsearch:
    image: ${registry_url}/hmpps-elasticsearch:${version}
    volumes:
      - ${es_home}/elasticsearch/data:/usr/share/elasticsearch/data
      - ${es_home}/elasticsearch/conf.d:/usr/share/elasticsearch/conf.d
    environment:
      - HMPPS_ES_CLUSTER_NAME=${aws_cluster}
      - HMPPS_ES_NODE_NAME=elasticsearch-${instance_identifier}
      - HMPPS_ES_MIN_MASTER_NODES=2
      - HMPPS_ES_CLUSTER_NODES_01=elasticsearch-1.${private_domain}
      - HMPPS_ES_CLUSTER_NODES_02=elasticsearch-2.${private_domain}
      - HMPPS_ES_CLUSTER_NODES_03=elasticsearch-3.${private_domain}
      - HMPPS_ES_CLUSTER_NODES_04=elasticsearch
      - HMPPS_ES_GATEWAY_EXPECTED_NODES=3
      - HMPPS_ES_GATEWAY_RECOVER_AFTER_TIME=5m
      - HMPPS_ES_GATEWAY_RECOVER_AFTER_NODES=2
      - HMPPS_ES_NETWORK_PUBLISH_HOST=`curl http://169.254.169.254/latest/meta-data/local-ipv4/`
    ports:
      - 9300:9300
      - 9200:9200
    ulimits:
      nofile: 65536

EOF

chown -R 1000:1000 ${es_home}/elasticsearch
chmod -R 777 ${es_home}/elasticsearch
ulimit -n 65536
docker-compose -f ${es_home}/service-elasticsearch/docker-compose.yml up -d