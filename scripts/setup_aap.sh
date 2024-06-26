#!/bin/bash
##
## Install Ansible Automation Platform
##

: "${BUNDLE_DIR={{ smc_bundle_dir }}}"
: "${AAP_BUNDLE={{ aap_bundle }}}"
: "${AAP_MANIFEST={{ aap_manifest }}}"
: "${AAP_PASSWORD=redhat}"
FQDN=$(hostname --fqdn)

tar -xvf ${BUNDLE_DIR}/${AAP_BUNDLE}
tar -xvf ${BUNDLE_DIR}/aap_postinstall.tgz
cd $(basename ${AAP_BUNDLE} .tar.gz)

sed -i.bak \
	-e "s/^fqdn_of_your_rhel_host/${FQDN}/" \
	-e "s/=fqdn_of_your_rhel_host/=${FQDN}/" \
	-e "s/^#\[database\]/[database]\n${FQDN} ansible_connection=local\n/" \
	-e "s/<set your own>/${AAP_PASSWORD}/" \
	-e "s/^#bundle_install=/bundle_install=/" \
	-e "s,^#bundle_dir=.*,bundle_dir=${HOME}/$(basename ${AAP_BUNDLE} .tar.gz)/bundle," \
	-e "s/^#controller_postinstall=.*/controller_postinstall=true/" \
	-e "s,^#controller_license_file=.*,controller_license_file=${BUNDLE_DIR}/${AAP_MANIFEST}," \
	-e "s,^#controller_postinstall_dir=.*,controller_postinstall_dir=${HOME}/aap_postinstall/controller," \
	inventory

ansible-playbook -i inventory ansible.containerized_installer.install
