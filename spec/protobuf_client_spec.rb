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
  end
end
