require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :ipaddress                 => '192.168.0.2',
    :operatingsystemmajrelease => '7',
    :fqdn                      => 'patchwork.example.com',
    :hostname                  => 'patchwork',
  }
  c.hiera_config = File.expand_path(File.join(__FILE__, '../fixtures/hiera.yaml'))
end

at_exit { RSpec::Puppet::Coverage.report! }
