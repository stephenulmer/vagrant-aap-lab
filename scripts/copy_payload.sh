#!/bin/sh
##
## Copy Installation Payload to SMC
##

## Variables set during Ansible template process
archives="{{ subdir_archives
             | map('regex_replace', '^(.*)$', '\\1.tgz')
             | join(' ') }}"

generated="ck.bundle payload_copy.sh payload_install.sh"

lpps="{{ lpps
	 | selectattr('bundle', 'defined')
	 | map(attribute='bundle')
	 | join(' ') }}"

other="{{ other_files
          | dict2items
          | map(attribute='value')
          | flatten
	  | join(' ') }}"

## FIXME: temporary until we start pre-processing again
archives=""; generated=""; lpps=""
other="${RHEL_ISO} ${AAP_BUNDLE} ${AAP_MANIFEST} aap_postinstall.tgz"

## Set variable to templated defaults only if they weren't already
## set. If running from kickstart, these will have been set in the
## enclosing %post script.
: "${BUNDLE_DIR={{ smc_bundle_dir }}}"
: "${PAYLOAD=/run/media/ansible/OEMDRV}"

MANIFEST=/tmp/payload-manifest.$$

##
## Copy payload from media
##

## Create payload manifest
for f in ${generated} ${archives} ${lpps} ${other} ; do
    echo ${f} >> $MANIFEST
done

mkdir -p ${BUNDLE_DIR}

## Copy files
rsync --size-only \
      --files-from=${MANIFEST} \
      --times \
      --perms \
      ${PAYLOAD} \
      ${BUNDLE_DIR}

## Remove payload manifest
rm -f ${MANIFEST}
