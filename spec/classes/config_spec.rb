require 'spec_helper'

describe 'patchwork::config', :type => 'class' do
  context 'with defaults for all parameters' do
    let(:params) {{
      :time_zone => 'US/PST',
      :from_email => '<patchwork@example.com>'
    }}
    it { should compile }
    it { should contain_file('/opt/patchwork/patchwork/settings/production.py')
           .with(
               'owner' => 'patchwork',
               'group' => 'patchwork',
            )
           .with_content(/TIME_ZONE = 'US\/PST'/)
           .with_content(/DEFAULT_FROM_EMAIL = '<patchwork@example.com>'/)
    }
  end
end
