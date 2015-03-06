require 'spec_helper'
describe 'basico' do

  context 'with defaults for all parameters' do
    it { should contain_class('basico') }
  end
end
