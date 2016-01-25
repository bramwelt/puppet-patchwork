require 'spec_helper'

describe 'patchwork', :type => 'class' do
  context 'with defaults for all parameters' do
    it { should contain_class('patchwork') }
    it { should contain_class('patchwork::install') }
    it { should contain_class('patchwork::database::mysql') }
    it { should contain_class('patchwork::config') }
    it { should contain_class('patchwork::cron') }
    it { should contain_class('mysql::server') }
    it { should contain_class('mysql::bindings')
           .with('python_enable' => true) }

    it { should contain_class('git') }

    it do
      should contain_vcsrepo('/opt/patchwork').with(
        'ensure'   => 'present',
        'user'     => 'patchwork',
        'group'    => 'patchwork',
        'provider' => 'git',
        'source'   => 'git://github.com/getpatchwork/patchwork',
      )
    end
  end
end
