#!/usr/bin/env bash
yum install -y python-pip git

cat << EOF >> /etc/environment
HMPPS_ROLE=${app_name}
HMPPS_FQDN=${app_name}.${private_domain}
HMPPS_STACKNAME=${env_identifier}
HMPPS_STACK="${short_env_identifier}"
HMPPS_ENVIRONMENT=${route53_sub_domain}
HMPPS_ACCOUNT_ID="${account_id}"
HMPPS_DOMAIN="${private_domain}"
EOF

## Ansible runs in the same shell that has just set the env vars for future logins so it has no knowledge of the vars we've
## just configured, so lets export them
export HMPPS_ROLE="${app_name}"
export HMPPS_FQDN="${app_name}.${private_domain}"
export HMPPS_STACKNAME="${env_identifier}"
export HMPPS_STACK="${short_env_identifier}"
export HMPPS_ENVIRONMENT=${route53_sub_domain}
export HMPPS_ACCOUNT_ID="${account_id}"
export HMPPS_DOMAIN="${private_domain}"

cd ~
pip install --upgrade pip
pip install ansible

cat << EOF > ~/requirements.yml
- name: bootstrap
  src: https://github.com/ministryofjustice/hmpps-bootstrap
  version: centos
- name: rsyslog
  src: https://github.com/ministryofjustice/hmpps-rsyslog-role
- name: elasticbeats
  src: https://github.com/ministryofjustice/hmpps-beats-monitoring
- name: nfs
  src: https://github.com/ministryofjustice/hmpps-nfs
  version: nfsServer
- name: users
  src: singleplatform-eng.users
EOF

wget https://raw.githubusercontent.com/ministryofjustice/hmpps-delius-ansible/master/group_vars/${bastion_inventory}.yml -O users.yml

cat << EOF > ~/vars.yml
monitoring_host: monitoring.${private_domain}
lvm_disks: [${device_list}]
lvm_mount_point: ${mount_point}
vg_name: ${volume_group_name}
lv_name: ${logical_volume_name}
lv_size: "{{ ((${device_size}*${device_count}))-2 }}G" #Remove 2 gigs from our total available as a rule of thumb

## NFS data
is_nfs_server: true
nfs_share: ${mount_point}
allowed_ip_ranges: [${allowed_ip_ranges}]
EOF

cat << EOF > ~/bootstrap.yml
---

- hosts: localhost
  vars_files:
    - "~/vars.yml"
    - "~/users.yml"
  roles:
     - bootstrap
     - rsyslog
     - elasticbeats
     - users
     - nfs

EOF

ansible-galaxy install -f -r ~/requirements.yml
ansible-playbook ~/bootstrap.yml -vvv
