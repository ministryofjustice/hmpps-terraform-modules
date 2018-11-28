#!/bin/bash
set -x
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1
echo BEGIN
date '+%Y-%m-%d %H:%M:%S'

yum install -y wget git python-pip jq
pip install -U pip
pip install ansible

cat << EOF >> /etc/environment
HMPPS_ROLE="${app_name}"
HMPPS_FQDN="${app_name}.${private_domain}"
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

cat << EOF > ~/requirements.yml
---

- name: bootstrap
  src: https://github.com/ministryofjustice/hmpps-bootstrap
  version: centos
- name: users
  src: singleplatform-eng.users
- name: oracle-db
  src: https://github.com/ministryofjustice/hmpps-delius-core-oracledb-bootstrap.git
  version: feature/oracle-db-vars_ssm
EOF

/usr/bin/curl -o ~/users.yml https://raw.githubusercontent.com/ministryofjustice/hmpps-delius-ansible/master/group_vars/${bastion_inventory}.yml


cat << EOF > ~/vars.yml
region: "${region}"

service_user_name: "${service_user_name}"
database_global_database_name: "${database_global_database_name}"
database_sid: "${database_sid}"
database_characterset: "${database_characterset}"

# These values are to be updated when the are injected and pulled from paramstore, consumed by oradb bootstrap
# oradb_sys_password
# oradb_system_password
# oradb_sysman_password
# oradb_dbsnmp_password
# oradb_asmsnmp_password

EOF
cat << EOF > ~/bootstrap.yml
---

- hosts: localhost
  vars_files:
   - "{{ playbook_dir }}/vars.yml"
   - "{{ playbook_dir }}/users.yml"
  roles:
     - bootstrap
     - users
     - oracle-db
EOF

# get ssm parmaeters
PARAM=$(aws ssm get-parameters \
--region eu-west-2 \
--with-decryption --name \
"/${route53_sub_domain}/delius-core/oracle-database/db/oradb_sys_password" \
"/${route53_sub_domain}/delius-core/oracle-database/db/oradb_system_password" \
"/${route53_sub_domain}/delius-core/oracle-database/db/oradb_sysman_password" \
"/${route53_sub_domain}/delius-core/oracle-database/db/oradb_dbsnmp_password" \
"/${route53_sub_domain}/delius-core/oracle-database/db/oradb_asmsnmp_password" \
--query Parameters)

# set parameter values
oradb_sys_password="$(echo $PARAM | jq '.[] | select(.Name | test("oradb_sys_password")) | .Value' --raw-output)"
oradb_system_password="$(echo $PARAM | jq '.[] | select(.Name | test("oradb_system_password")) | .Value' --raw-output)"
oradb_sysman_password="$(echo $PARAM | jq '.[] | select(.Name | test("oradb_sysman_password")) | .Value' --raw-output)"
oradb_dbsnmp_password="$(echo $PARAM | jq '.[] | select(.Name | test("oradb_dbsnmp_password")) | .Value' --raw-output)"
oradb_asmsnmp_password="$(echo $PARAM | jq '.[] | select(.Name | test("oradb_asmsnmp_password")) | .Value' --raw-output)"

export ANSIBLE_LOG_PATH=$HOME/.ansible.log

ansible-galaxy install -f -r ~/requirements.yml
CONFIGURE_SWAP=true SELF_REGISTER=true ansible-playbook ~/bootstrap.yml \
--extra-vars '\
"oradb_sys_password":"$oradb_sys_password", \
"oradb_system_password":"$oradb_system_password", \
"oradb_sysman_password":"$oradb_sysman_password", \
"oradb_dbsnmp_password":"$oradb_dbsnmp_password", \
"oradb_asmsnmp_password":"$oradb_asmsnmp_password", \
'
