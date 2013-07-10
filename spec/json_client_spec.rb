require 'spec_helper'

describe Betterific::JsonClient do
  [:most_popular, :most_recent].each do |filter|
    it "should load #{filter} betterifs" do
      j = Betterific::JsonClient.betterifs(filter)
      ensure_valid_betterif_json_response(j, :big => true)
    end
  end
  it "should load betterifs via ids" do
    j = Betterific::JsonClient.betterifs(:ids => 224)
    ensure_valid_betterif_json_response(j)
    j['total_results'].should == 1
    j['num_results'].should == 1
    j['betterifs'].size.should == 1
    j['betterifs'].first.has_key?('tags').should == true
    j['betterifs'].first['tags'].is_a?(Array).should == true
    j['betterifs'].first.has_key?('user').should == true
    j['betterifs'].first['user'].is_a?(Hash).should == true
  end
  it "should load tags via ids" do
    betterific_tag_id = 400973
    j = Betterific::JsonClient.tags(:ids => betterific_tag_id)
    j.is_a?(Hash).should == true
    j.has_key?('total_results').should == true
    j['total_results'].should == 1
    j.has_key?('num_results').should == true
    j['num_results'].should == 1
    j.has_key?('tags').should == true
    j['tags'].size.should == 1
    j['tags'].first.has_key?('id').should == true
    j['tags'].first['id'].should == betterific_tag_id
  end
end
