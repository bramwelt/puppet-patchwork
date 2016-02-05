require 'spec_helper'

describe 'patchwork', :type => 'class' do
  context 'install' do
    context 'with defaults for all parameters' do
      it { should contain_class('git') } 
      it { should contain_class('python') } 
      it { should contain_class('mysql::server') } 
      # Uncomment this once the mysql module has been updated
      #it { should contain_class('mysql::bindings::daemon_dev') }
      # Remove the following check once mysql has been updated
      it { should contain_package('mysql-daemon_dev')
        .with({
          'ensure' => 'present',
          'name' => 'mariadb-devel',
        })
      }
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
          'owner'        => 'patchwork',
          'group'        => 'patchwork',
        })
      }
      it { should contain_python__requirements('/opt/patchwork/docs/requirements-prod.txt')
        .with({
          'virtualenv'   => '/opt/patchwork/venv',
          'owner'        => 'patchwork',
          'group'        => 'patchwork',
          'forceupdate'  => 'true',
        })
      }
      it { should contain_class('uwsgi') }
      it { should contain_uwsgi__app('patchwork')
        .with({
          'ensure'              => 'present',
          'application_options' => {
            'virtualenv' => '/opt/patchwork/venv',
            'chdir'      => '/opt/patchwork',
            'logto'      => '/var/log/patchwork/uwsgi.log',
            'master'     => true,
            'http-socket' => ':9000',
            'wsgi-file' => 'patchwork/patchwork.wsgi',
            'static-map' => '/static=/opt/patchwork/static',
            'processes' => 4,
            'threads' => 2,
          }
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
