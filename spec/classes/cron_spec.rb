require 'spec_helper'

describe 'patchwork', :type => 'class' do
  context 'with defaults for parameters used by cron' do
    let(:params) {{
      :virtualenv_dir => '/fakevirtualenv',
      :install_dir   => '/foo/lib',
    }}
    it { should compile }
    it { should contain_cron('patchwork').with(
      'command' => '/fakevirtualenv/bin/python /foo/lib/manage.py cron')}
  end
end
