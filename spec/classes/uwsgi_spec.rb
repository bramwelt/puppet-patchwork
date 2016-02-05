require 'spec_helper'

describe 'patchwork', :type => 'class' do
  context 'uwsgi' do
    context 'with defaults for all parameters' do
      it { should compile }
      it { should contain_class('patchwork::uwsgi') }
      it { should contain_class('uwsgi') }
      it { should contain_file('/var/log/patchwork')
           .with({
               'ensure' => 'directory',
           })
      }
      it { should contain_uwsgi__app('patchwork')
        .with({
          'ensure'              => 'present',
          'application_options' => {
            'virtualenv' => '/opt/patchwork/venv',
            'chdir'      => '/opt/patchwork',
            'logto'      => '/var/log/patchwork/uwsgi.log',
            'master'     => true,
            'http-socket' => ':9000',
            'static-map' => '/static=/opt/patchwork/static',
            'wsgi-file' => 'patchwork.wsgi',
            'processes' => 4,
            'threads' => 2,
          }
        })
      }
    end
  end
end
