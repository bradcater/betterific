require 'spec_helper'

if defined?(Betterific::ProtobufClient)
  describe Betterific::ProtobufClient do
    [:most_popular, :most_recent].each do |filter|
      it "should load #{filter} betterifs" do
        bar = Betterific::ProtobufClient.betterifs(filter)
        ensure_valid_betterif_protobuf_response(bar, :big => true)
      end
    end
    it "should load betterifs via ids" do
      bar = Betterific::ProtobufClient.betterifs(:ids => 224)
      ensure_valid_betterif_protobuf_response(bar)
    end
    it "should load tags via ids" do
      betterific_tag_id = 400973
      bar = Betterific::ProtobufClient.tags(:ids => betterific_tag_id)
      bar.is_a?(BetterIf::TagApiResponse).should == true
      bar.total_results.should == 1
      bar.num_results.should == 1
      bar.tags.size.should == 1
      bar.tags.is_a?(ProtocolBuffers::RepeatedField).should == true
      bar.tags.first.is_a?(BetterIf::Tag)
      bar.tags.first.id.should == betterific_tag_id
    end
    it "should load users via ids" do
      user_id = 2
      bar = Betterific::ProtobufClient.users(:ids => user_id)
      bar.is_a?(BetterIf::UserApiResponse).should == true
      bar.total_results.should == 1
      bar.num_results.should == 1
      bar.users.size.should == 1
      bar.users.is_a?(ProtocolBuffers::RepeatedField).should == true
      bar.users.first.is_a?(BetterIf::User)
      bar.users.first.id.should == user_id
    end
  end
end
