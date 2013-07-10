require 'betterific'

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
end

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
