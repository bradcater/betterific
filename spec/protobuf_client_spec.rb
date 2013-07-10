require 'spec_helper'

if defined?(Betterific::ProtobufClient)
  describe Betterific::ProtobufClient do
    [:most_popular, :most_recent].each do |filter|
      it "should load #{filter} betterifs" do
        bar = Betterific::ProtobufClient.betterifs(filter)
        bar.is_a?(BetterIf::BetterifApiResponse).should == true
        ensure_valid_protobuf_response(bar, :big => true)
      end
    end
    it "should load betterifs via ids" do
      bar = Betterific::ProtobufClient.betterifs(:ids => BETTERIF_ID)
      bar.is_a?(BetterIf::BetterifApiResponse).should == true
      ensure_valid_protobuf_response(bar, :betterifs => true)
      bar.betterifs.first.id.should == BETTERIF_ID
    end
    it "should load tags via ids" do
      bar = Betterific::ProtobufClient.tags(:ids => BETTERIFIC_TAG_ID)
      bar.is_a?(BetterIf::TagApiResponse).should == true
      ensure_valid_protobuf_response(bar, :tags => true)
      bar.tags.first.id.should == BETTERIFIC_TAG_ID
    end
    it "should load users via ids" do
      bar = Betterific::ProtobufClient.users(:ids => USER_ID)
      bar.is_a?(BetterIf::UserApiResponse).should == true
      ensure_valid_protobuf_response(bar, :users => true)
      bar.users.first.id.should == USER_ID
    end

    search_kinds = %w{betterifs tags users}
    search_kinds.each do |kind|
      it "should load search for #{kind}" do
        q = random_query
        bar = Betterific::ProtobufClient.search(:namespace => kind, :q => q)
        bar.q.should == q
        ensure_valid_protobuf_response(bar.send(kind), kind.to_sym => true, :allow_empty => true)
        search_kinds.each do |other_kind|
          next if kind == other_kind
          bar.send(other_kind).send(other_kind).size.should == 0
        end
      end
    end
    it "should load search for all" do
      q = random_query
      bar = Betterific::ProtobufClient.search(:namespace => :all, :q => q)
      bar.q.should == q
      search_kinds.each do |kind|
        ensure_valid_protobuf_response(bar.send(kind), kind.to_sym => true, :allow_empty => true)
      end
    end
  end
end
