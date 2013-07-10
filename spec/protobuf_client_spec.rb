require 'spec_helper'

if defined?(Betterific::ProtobufClient)
  def ensure_valid_betterif_protobuf_response(bar)
    bar.is_a?(BetterIf::BetterifApiResponse).should == true
    bar.total_results.should > 10
    bar.num_results.should == 10
    bar.betterifs.size.should == 10
    bar.betterifs.first.tags.is_a?(ProtocolBuffers::RepeatedField).should == true
    if bar.betterifs.first.tags.size > 0
      bar.betterifs.first.tags.first.is_a?(BetterIf::Tag).should == true
    end
    bar.betterifs.first.user.is_a?(BetterIf::User).should == true
  end

  describe Betterific::ProtobufClient do
    [:most_popular, :most_recent].each do |filter|
      it "should load #{filter} betterifs" do
        bar = Betterific::ProtobufClient.betterifs(filter)
        ensure_valid_betterif_protobuf_response(bar)
      end
    end
  end
end
