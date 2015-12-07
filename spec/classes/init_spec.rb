require 'spec_helper'
describe 'patchwork', :type => 'class' do
  let (:facts) do { 
      :osfamily                  => 'RedHat',
      :operatingsystem           => 'CentOS',
      :operatingsystemmajrelease => '7',
      :ipaddress                 => '192.168.0.2',
      :fqdn                      => 'patchwork.example.com',
      :hostname                  => 'patchwork',
  }
  end

  context 'with defaults for all parameters' do

    it { should contain_class('patchwork') }

    it { should contain_package('git').with_ensure('installed') }

    it do
      should contain_vcsrepo('/opt/patchwork').with(
        'ensure'   => 'present',
        'provider' => 'git',
        'source'   => 'git://github.com/getpatchwork/patchwork',
      )
    end
  end
end
