#!/bin/bash
##
## Mount RHEL ISO and Setup Temporary RHEL Repository
##

: "${BUNDLE_DIR={{ smc_bundle_dir }}}"
: "${RHEL_ISO=rhel-9.4-aarch64-dvd.iso}"
: "${REPO_ROOT=/repo}"
REPO_RHEL=${REPO_ROOT}/$(basename ${RHEL_ISO} -dvd.iso)

mkdir -p ${REPO_RHEL}

cat >> /etc/fstab <<-EOF # heredoc indent MUST be a tab
	${BUNDLE_DIR}/${RHEL_ISO}	${REPO_RHEL}	iso9660	ro,nofail	0 0
EOF

systemctl daemon-reload
mount ${REPO_RHEL}

dnf config-manager --add-repo file://${REPO_RHEL}/BaseOS
dnf config-manager --add-repo file://${REPO_RHEL}/AppStream
dnf install -y ansible-core wget git rsync
