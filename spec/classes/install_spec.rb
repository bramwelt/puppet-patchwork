require 'spec_helper'

describe 'patchwork', :type => 'class' do
  context 'install' do
    context 'with defaults for all parameters' do
      it { should contain_class('git') } 
      it { should contain_class('python') } 
      it { should contain_class('mysql::server') } 
      it { should contain_class('mysql::bindings')
        .with({
          'python_enable' => 'true'
        })
      } 
      it { should contain_vcsrepo('/opt/patchwork')
        .with({
          'ensure' => 'present',
          'source' => 'git://github.com/getpatchwork/patchwork',
          'revision' => 'master',
        })
      }
      it { should contain_python__virtualenv('/opt/patchwork/venv')
        .with({
          'requirements' => '/opt/patchwork/docs/requirements-prod.txt',
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
        })
      }
    end
  end
end
