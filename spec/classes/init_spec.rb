require 'spec_helper'
describe 'patchwork' do

  context 'with defaults for all parameters' do
    it { should contain_class('patchwork') }
  end
end
