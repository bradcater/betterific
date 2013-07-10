require 'betterific'

def ensure_valid_betterif_json_response(j, opts={})
  j.is_a?(Hash).should == true
  j.has_key?('total_results').should == true
  if opts[:big]
    j['total_results'].should > 10
  end
  j.has_key?('num_results').should == true
  if opts[:big]
    j['num_results'].should == 10
  end
  j.has_key?('betterifs').should == true
  if opts[:big]
    j['betterifs'].size.should == 10
  end
  j['betterifs'].first.has_key?('tags').should == true
  j['betterifs'].first['tags'].is_a?(Array).should == true
  j['betterifs'].first.has_key?('user').should == true
  j['betterifs'].first['user'].is_a?(Hash).should == true
end

if defined?(Betterific::ProtobufClient)
  def ensure_valid_betterif_protobuf_response(bar, opts={})
    bar.is_a?(BetterIf::BetterifApiResponse).should == true
    if opts[:big]
      bar.total_results.should > 10
    else
      bar.total_results.present?.should == true
    end
    if opts[:big]
      bar.num_results.should == 10
    else
      bar.num_results.present?.should == true
    end
    if opts[:big]
      bar.betterifs.size.should == 10
    else
      bar.betterifs.size.present?.should == true
    end
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
