require 'spec_helper'

describe 'patchwork::database::mysql', :type => 'class' do
  let :pre_condition do
      'Mysql::Db <<| |>>'
  end
  context 'with defaults for all parameters' do
    it { should compile }
    it { should contain_mysql__db('patchwork').with({
             'dbname'   => 'patchwork',
             'user'     => 'patchwork',
             'password' => 'patchwork',
             'host'     => '172.16.32.42',
           }) }
  end
  context 'with exported resourced enabled' do
    let (:facts) {{
        :fqdn => 'patchwork.example'
    }}
    it { should_not contain_mysql__db('patchwork') }
    it { should contain_mysql__db('patchwork_patchwork.example').with({
             'dbname'   => 'patchwork',
             'user'     => 'patchwork',
             'password' => 'patchwork',
             'host'     => '172.16.32.42',
           }) }
  end
end
