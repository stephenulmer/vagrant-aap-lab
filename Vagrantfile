# -*- mode: ruby -*-
# vi: set ft=ruby :

vm_name = "aap-lab"

penv = { 'BUNDLE_DIR'   => "/export/bundles",
         'DOCROOT'      => "/export",
         'PAYLOAD'      => "/vagrant/payload",
         'RHEL_ISO'     => "rhel-9.4-aarch64-dvd.iso",
         'AAP_BUNDLE'   => "ansible-automation-platform-containerized-setup-bundle-2.4-2-aarch64.tar.gz",
         'AAP_MANIFEST' => "rh-manifest.zip",
         'AAP_PASSWORD' => "redhat" }

Vagrant.configure("2") do |config|
  config.vm.box = "slu/rhel-9.4"
  config.vm.box_check_update = false
  config.vm.hostname = vm_name + ".localdomain"
  config.vm.define vm_name

  config.vm.provider "parallels" do |prl|
    prl.name = vm_name
    prl.update_guest_tools = true
    ## Additional drive for GPFS file system
    #prl.customize ["set", :id, "--device-add", "hdd", "--size", "5120", "--iface", "scsi"]
  end

  ##
  ## Each provisioner can be a modular part of the kickstart %post script
  ##
  config.vm.provision "Copy Payload from Media", type: "shell" do |p|
    p.path = "scripts/copy_payload.sh"
    p.privileged = true
    p.env = penv
  end

  config.vm.provision "Setup DNF Repositories", type: "shell" do |p|
    p.path = "scripts/setup_repos.sh"
    p.privileged = true
    p.env = penv
  end

  config.vm.provision "Install AAP", type: "shell" do |s|
    s.path = "scripts/setup_aap.sh"
    s.privileged = false
    s.env = penv
  end
end
