require 'spec_helper'

describe 'patchwork::config', :type => 'class' do
  context 'with defaults for all parameters' do
    let(:params) {{
      :time_zone => 'US/PST',
    }}
    it { should compile }
    it { should contain_file('/opt/patchwork/patchwork/settings/production.py')
           .with_content(/TIME_ZONE = US\/PST/)}
  end
end
