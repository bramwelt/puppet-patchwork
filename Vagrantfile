# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "puppetlabs/centos-7.0-64-puppet"

  config.vm.synced_folder '.', '/etc/puppet/modules/patchwork'

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'tests'
    puppet.manifest_file = 'init.pp'
    # puppet.options = '--verbose --debug'
  end

end
