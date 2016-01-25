require 'spec_helper'

describe 'patchwork::config', :type => 'class' do
  context 'with defaults for all parameters' do
    it { should compile }
    it { should contain_file('/opt/patchwork/patchwork/settings/production.py')
           .with_content(/LANGUAGE_CODE = 'en_US'/)
           .with_content(/FORCE_HTTPS_LINKS = False/)
           .with_content(/DEFAULT_PATCHES_PER_PAGE = 10/)
           .with_content(/DEFAULT_FROM_EMAIL = 'Patchwork <patchwork@patchwork.example.com>'/)
           .with_content(/NOTIFICATION_DELAY_MINUTES = 10/)
           .with_content(/TIME_ZONE = 'Etc\/UTC'/)
    }
  end
  context 'with defaults for all parameters' do
    let(:params) {{
      :time_zone => 'US/PST',
      :from_email => '<foo@example.com>',
      :notification_delay => '20',
      :language_code => 'American/New_York',
      :patches_per_page => '80',
      :language_code => 'fi-SE',
      :force_https_links => 'True',
    }}
    it { should compile }
    it { should contain_file('/opt/patchwork/patchwork/settings/production.py')
           .with(
               'owner' => 'patchwork',
               'group' => 'patchwork',
            )
           .with_content(/LANGUAGE_CODE = 'fi-SE'/)
           .with_content(/TIME_ZONE = 'US\/PST'/)
           .with_content(/DEFAULT_FROM_EMAIL = '<foo@example.com>'/)
           .with_content(/NOTIFICATION_DELAY_MINUTES = 20/)
           .with_content(/FORCE_HTTPS_LINKS = True/)
           .with_content(/DEFAULT_PATCHES_PER_PAGE = 80/)
    }
  end
end
