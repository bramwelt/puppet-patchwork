require 'spec_helper'

describe 'patchwork', :type => 'class' do
  context 'install' do
    context 'with defaults for all parameters' do
      it { should contain_class('git') } 
      it { should contain_class('python') } 
      it { should contain_class('mysql::server') } 
      it { should contain_class('mysql::bindings::daemon_dev') }
      it { should contain_class('mysql::bindings')
        .with({
          'python_enable' => 'true'
        })
      } 
      it { should contain_user('patchwork')
           .with({
               'ensure'  => 'present',
               'comment' => 'User for managing Patchwork',
               'home'    => '/opt/patchwork',
               'system'  => true,
           })
      }
      it { should contain_vcsrepo('/opt/patchwork')
        .with({
          'ensure' => 'present',
          'user'   => 'patchwork',
          'group'  => 'patchwork',
          'source' => 'git://github.com/getpatchwork/patchwork',
          'revision' => 'master',
        })
      }
      it { should contain_python__virtualenv('/opt/patchwork/venv')
        .with({
          'requirements' => '/opt/patchwork/docs/requirements-prod.txt',
          'owner'        => 'patchwork',
          'group'        => 'patchwork',
        })
      }
    end
    context 'with specific patchwork version' do
      let(:params) {{
        :version => '1.2.3',
      }}
      it { should contain_vcsrepo('/opt/patchwork')
        .with({
          'ensure' => 'present',
          'source' => 'git://github.com/getpatchwork/patchwork',
          'revision' => '1.2.3',
          'user'     => 'patchwork',
          'group'    => 'patchwork',
        })
      }
    end
    context 'with latest patchwork version' do
      let(:params) {{
        :version => 'latest',
      }}
      it { should contain_vcsrepo('/opt/patchwork')
        .with({
          'ensure' => 'latest',
          'source' => 'git://github.com/getpatchwork/patchwork',
          'revision' => 'master',
          'user'     => 'patchwork',
          'group'    => 'patchwork',
        })
      }
    end
    context 'with hiera version data' do
      let (:facts) {{
          :fqdn => 'patchwork.example'
      }}
      it { should contain_vcsrepo('/opt/patchwork')
        .with({
          'ensure' => 'present',
          'source' => 'git://github.com/getpatchwork/patchwork',
          'revision' => 'v1.0.0',
          'user'     => 'patchwork-user',
          'group'    => 'patchwork-group',
        })
      }
    end
  end
end
