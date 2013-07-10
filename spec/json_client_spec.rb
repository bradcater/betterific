require 'spec_helper'

def ensure_valid_betterif_json_response(j)
  j.is_a?(Hash).should == true
  j.has_key?('total_results').should == true
  j['total_results'].should > 10
  j.has_key?('num_results').should == true
  j['num_results'].should == 10
  j.has_key?('betterifs').should == true
  j['betterifs'].size.should == 10
  j['betterifs'].first.has_key?('tags').should == true
  j['betterifs'].first['tags'].is_a?(Array).should == true
  j['betterifs'].first.has_key?('user').should == true
  j['betterifs'].first['user'].is_a?(Hash).should == true
end

describe Betterific::JsonClient do
  [:most_popular, :most_recent].each do |filter|
    it "should load #{filter} betterifs" do
      j = Betterific::JsonClient.betterifs(filter)
      ensure_valid_betterif_json_response(j)
    end
  end
end
