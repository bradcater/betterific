require 'spec_helper'

if defined?(Betterific::ProtobufClient)
  describe Betterific::ProtobufClient do
    [['without page params', {}],
     ['with page params', {:page => 2, :per_page => 1}]].each do |(page_params_lbl, page_params)|
      [:most_popular, :most_recent].each do |filter|
        it "should load #{filter} betterifs" do
          bar = Betterific::ProtobufClient.betterifs(page_params.merge(:filter => filter))
          bar.is_a?(BetterIf::BetterifApiResponse).should == true
          ensure_valid_protobuf_response(bar, :big => page_params.empty?)
        end
      end
      it "should load betterifs via ids" do
        bar = Betterific::ProtobufClient.betterifs(page_params.merge(:ids => BETTERIF_ID))
        bar.is_a?(BetterIf::BetterifApiResponse).should == true
        ensure_valid_protobuf_response(bar, :betterifs => true, :allow_empty => !page_params.empty?)
        if page_params.empty?
          bar.betterifs.first.id.should == BETTERIF_ID
        end
      end
      it "should load tags via ids" do
        bar = Betterific::ProtobufClient.tags(page_params.merge(:ids => BETTERIFIC_TAG_ID))
        bar.is_a?(BetterIf::TagApiResponse).should == true
        ensure_valid_protobuf_response(bar, :tags => true, :allow_empty => !page_params.empty?)
        if page_params.empty?
          bar.tags.first.id.should == BETTERIFIC_TAG_ID
        end
      end
      it "should load users via ids" do
        bar = Betterific::ProtobufClient.users(page_params.merge(:ids => USER_ID))
        bar.is_a?(BetterIf::UserApiResponse).should == true
        ensure_valid_protobuf_response(bar, :users => true, :allow_empty => !page_params.empty?)
        if page_params.empty?
          bar.users.first.id.should == USER_ID
        end
      end

      search_kinds = %w{betterifs tags users}
      search_kinds.each do |kind|
        it "should load search for #{kind}" do
          q = random_query
          bar = Betterific::ProtobufClient.search(page_params.merge(:namespace => kind, :q => q))
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
        bar = Betterific::ProtobufClient.search(page_params.merge(:namespace => :all, :q => q))
        bar.q.should == q
        search_kinds.each do |kind|
          ensure_valid_protobuf_response(bar.send(kind), kind.to_sym => true, :allow_empty => true)
        end
      end
    end
  end
end
