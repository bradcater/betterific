require 'spec_helper'

describe Betterific::JsonClient do
  [['without page params', {}],
   ['with page params', {:page => 2, :per_page => 1}]].each do |(page_params_lbl, page_params)|
    [:most_popular, :most_recent].each do |filter|
      it "should load #{filter} betterifs #{page_params_lbl}" do
        j = Betterific::JsonClient.betterifs(page_params.merge(:filter => filter))
        ensure_valid_json_response(j, :betterifs => true, :big => page_params.empty?)
      end
    end
    it "should load betterifs via ids #{page_params_lbl}" do
      j = Betterific::JsonClient.betterifs(page_params.merge(:ids => BETTERIF_ID))
      ensure_valid_json_response(j, :betterifs => true, :allow_empty => !page_params.empty?)
      if page_params.empty?
        j['betterifs'].first['id'].should == BETTERIF_ID
      end
    end
    it "should load tags via ids #{page_params_lbl}" do
      j = Betterific::JsonClient.tags(page_params.merge(:ids => BETTERIFIC_TAG_ID))
      ensure_valid_json_response(j, :tags => true, :allow_empty => !page_params.empty?)
      if page_params.empty?
        j['tags'].first['id'].should == BETTERIFIC_TAG_ID
      end
    end
    it "should load users via ids #{page_params_lbl}" do
      j = Betterific::JsonClient.users(page_params.merge(:ids => USER_ID))
      ensure_valid_json_response(j, :users => true, :allow_empty => !page_params.empty?)
      if page_params.empty?
        j['users'].first['id'].should == USER_ID
      end
    end

    search_kinds = %w{betterifs tags users}
    search_kinds.each do |kind|
      it "should load search for #{kind} #{page_params_lbl}" do
        q = random_query
        j = Betterific::JsonClient.search(page_params.merge(:namespace => kind, :q => q))
        j.has_key?('q').should == true
        j['q'].should == q
        ensure_valid_json_response(j[kind], kind.to_sym => true, :allow_empty => true)
        search_kinds.each do |other_kind|
          next if kind == other_kind
          j[other_kind].present?.should == false
        end
      end
    end
    it "should load search for all #{page_params_lbl}" do
      q = random_query
      j = Betterific::JsonClient.search(page_params.merge(:namespace => :all, :q => q))
      j.has_key?('q').should == true
      j['q'].should == q
      search_kinds.each do |kind|
        ensure_valid_json_response(j[kind], kind.to_sym => true, :allow_empty => true)
      end
    end
  end
end
