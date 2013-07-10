require 'spec_helper'

describe Betterific::JsonClient do
  [:most_popular, :most_recent].each do |filter|
    it "should load #{filter} betterifs" do
      j = Betterific::JsonClient.betterifs(filter)
      ensure_valid_json_response(j, :betterifs => true, :big => true)
    end
  end
  it "should load betterifs via ids" do
    j = Betterific::JsonClient.betterifs(:ids => BETTERIF_ID)
    ensure_valid_json_response(j, :betterifs => true)
    j['betterifs'].first['id'].should == BETTERIF_ID
  end
  it "should load tags via ids" do
    j = Betterific::JsonClient.tags(:ids => BETTERIFIC_TAG_ID)
    ensure_valid_json_response(j, :tags => true)
    j['tags'].first['id'].should == BETTERIFIC_TAG_ID
  end
  it "should load users via ids" do
    j = Betterific::JsonClient.users(:ids => USER_ID)
    ensure_valid_json_response(j, :users => true)
    j['users'].first['id'].should == USER_ID
  end

  search_kinds = %w{betterifs tags users}
  search_kinds.each do |kind|
    it "should load search for #{kind}" do
      q = random_query
      j = Betterific::JsonClient.search(:namespace => kind, :q => q)
      j.has_key?('q').should == true
      j['q'].should == q
      ensure_valid_json_response(j[kind], kind.to_sym => true, :allow_empty => true)
      search_kinds.each do |other_kind|
        next if kind == other_kind
        j[other_kind].present?.should == false
      end
    end
  end
  it "should load search for all" do
    q = random_query
    j = Betterific::JsonClient.search(:namespace => :all, :q => q)
    j.has_key?('q').should == true
    j['q'].should == q
    search_kinds.each do |kind|
      ensure_valid_json_response(j[kind], kind.to_sym => true, :allow_empty => true)
    end
  end
end
