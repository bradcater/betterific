require 'spec_helper'

describe Betterific do
  it 'should return correct version string' do
    Betterific.version_string.should == "Betterific version #{Betterific::VERSION}"
  end
end
