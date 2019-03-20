#!/usr/bin/env bash

yum install -y python-pip git wget

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
- name: users
  src: singleplatform-eng.users
EOF

cat << EOF > ~/bootstrap_vars.yml
mount_point: "${es_home}"
device_name: "${ebs_device}"
monitoring_host: "monitoring.${private_domain}"
efs_mount_dir: "${efs_mount_dir}"
efs_file_system_id: "${efs_file_system_id}"
region: "${region}"
EOF

wget https://raw.githubusercontent.com/ministryofjustice/hmpps-delius-ansible/master/group_vars/${bastion_inventory}.yml -O users.yml

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
  tasks:
    - name: Create the elasticsearch group
      group:
        name: elasticsearch
        gid: 3999
        state: present
    - name: Add an elasticsearch user
      user:
        name: elasticsearch
        groups:
          - elasticsearch
          - docker
        uid: 101
        system: true
        state: present
EOF


ansible-galaxy install -f -r ~/requirements.yml
ansible-playbook ~/bootstrap.yml


#Create docker-compose file and env file
mkdir -p ${es_home}/service-elasticsearch ${es_home}/elasticsearch/data ${es_home}/elasticsearch/conf.d /opt/curator

if [ "x${efs_mount_dir}" == "x" ];then

cat << EOF > ${es_home}/service-elasticsearch/docker-compose.yml
version: "3"

services:
  elasticsearch:
    image: ${registry_url}/${image_name}:${version}
    volumes:
      - ${es_home}/elasticsearch/data:/usr/share/elasticsearch/data
      - ${es_home}/elasticsearch/conf.d:/usr/share/elasticsearch/conf.d
      - /opt/curator:/opt/curator
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
else
cat << EOF > ${es_home}/service-elasticsearch/docker-compose.yml
version: "3"

services:
  elasticsearch:
    image: ${registry_url}/${image_name}:${version}
    volumes:
      - ${es_home}/elasticsearch/data:/usr/share/elasticsearch/data
      - ${es_home}/elasticsearch/conf.d:/usr/share/elasticsearch/conf.d
      - ${efs_mount_dir}:${efs_mount_dir}
      - /opt/curator:/opt/curator
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
      - HMPPS_ES_PATH_REPO=${efs_mount_dir}
    ports:
      - 9300:9300
      - 9200:9200
    ulimits:
      nofile: 65536
EOF
chown -R `id -u elasticsearch`:`id -g elasticsearch` ${efs_mount_dir}
chmod -R 775 ${efs_mount_dir}
fi

#Create our curator templates
cat << EOF > /opt/curator/backup.yml
---

actions:
  1:
    action: snapshot
    description: "Create snapshot of ${aws_cluster}"
    options:
      repository: "${aws_cluster}-backup"
      continue_if_exception: False
      wait_for_completion: True
    filters:
      - filtertype: pattern
        kind: regex
        value: ".*$"

EOF

cat << EOF > /opt/curator/prune.yml
---

actions:
  1:
    action: delete_indices
    description: "Prune indices on ${aws_cluster}"
    options:
      ignore_empty_list: True
      disable_action: False
    filters:
    - filtertype: age
      source: creation_date
      direction: older
      unit: days
      unit_count: 365
    - filtertype: pattern
      kind: regex
      value: '*'

EOF

chown -R `id -u elasticsearch`:`id -g elasticsearch` ${es_home}/elasticsearch /opt/curator
chmod -R 775 ${es_home}/elasticsearch /opt/curator

ulimit -n 65536
sysctl -w vm.max_map_count=262144
service docker restart
sleep 10
docker-compose -f ${es_home}/service-elasticsearch/docker-compose.yml up -d

#Wait for elasticsearch to come up
sleep 60
sudo docker exec -ti service-monitoring_elasticsearch_1 bash -c \
    "es_repo_mgr create fs --config /usr/share/elasticsearch/.curator/curator.yml --repository ${aws_cluster}-backup --location ${efs_mount_dir} --compression true"


