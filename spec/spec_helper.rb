require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :ipaddress                 => '172.16.32.42',
    :operatingsystemmajrelease => '7',
    :operatingsystemrelease    => '7.0',
    :fqdn                      => 'patchwork.example.com',
    :hostname                  => 'patchwork',
    :virtualenv_version        => '1.10.1'
  }
  c.hiera_config = File.expand_path(File.join(__FILE__, '../fixtures/hiera.yaml'))
end

at_exit { RSpec::Puppet::Coverage.report! }
