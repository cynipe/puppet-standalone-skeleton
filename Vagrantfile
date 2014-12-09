# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'jayunit100/centos7'
  config.vm.network :private_network, :ip => '10.240.0.10'
  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '512']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'off']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'off']
  end

  config.vm.provision :shell, :inline => (<<-SCRIPT).gsub(/^ */, '')
    yum -y update puppet
    (gem spec hiera-eyaml > /dev/null 2>&1) || {
      gem install hiera-eyaml --no-rdoc --no-ri
    }
    (gem spec deep_merge > /dev/null 2>&1) || {
      gem install deep_merge --no-rdoc --no-ri
    }
  SCRIPT

  config.vm.provision :puppet do |puppet|
    puppet.manifest_file     = 'site.pp'
    puppet.manifests_path    = 'manifests'
    puppet.module_path       = [ 'modules', 'shared' ]
    puppet.hiera_config_path = 'config/hiera.yaml'
    puppet.facter            = {
      :hieradata_dir => '/vagrant/hieradata',
      :image         => 'app1',
    }
    puppet.options           = '--show_diff'
  end

end
