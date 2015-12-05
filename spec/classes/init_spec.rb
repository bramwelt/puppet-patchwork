require 'spec_helper'
describe 'patchwork', :type => 'class' do

  context 'with defaults for all parameters' do
    let (:facts) do { 
        :osfamily => 'RedHat',
        :operatingsystem => 'CentOS',
    }
    end

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
