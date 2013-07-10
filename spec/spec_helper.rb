require 'betterific'

BETTERIFIC_TAG_ID = 400937
BETTERIF_ID = 224
USER_ID = 2

def ensure_valid_json_response(j, opts={})
  j.is_a?(Hash).should == true
  j.has_key?('total_results').should == true
  if opts[:big]
    j['total_results'].should > 10
  end
  j.has_key?('num_results').should == true
  if opts[:big]
    j['num_results'].should == 10
  end
  if opts[:betterifs]
    j.has_key?('betterifs').should == true
    if opts[:big]
      j['betterifs'].size.should == 10
    else
      j['betterifs'].size.should >= (opts[:allow_empty] ? 0 : 1)
    end
    j['betterifs'].first.has_key?('tags').should == true
    j['betterifs'].first['tags'].is_a?(Array).should == true
    j['betterifs'].first.has_key?('user').should == true
    j['betterifs'].first['user'].is_a?(Hash).should == true
  end
  if opts[:tags]
    j.has_key?('tags').should == true
    if opts[:big]
      j['tags'].size.should == 10
    else
      j['tags'].size.should >= (opts[:allow_empty] ? 0 : 1)
    end
    j['tags'].first.has_key?('id').should == true
  end
  if opts[:users]
    j.has_key?('users').should == true
    if opts[:big]
      j['users'].size.should == 10
    else
      j['users'].size.should >= (opts[:allow_empty] ? 0 : 1)
    end
    j['users'].first.has_key?('id').should == true
  end
end

if defined?(Betterific::ProtobufClient)
  def ensure_valid_protobuf_response(bar, opts={})
    if opts[:big]
      bar.total_results.should > 10
    else
      bar.total_results.should >= (opts[:allow_empty] ? 0 : 1)
    end
    if opts[:big]
      bar.num_results.should == 10
    else
      bar.num_results.should >= (opts[:allow_empty] ? 0 : 1)
    end
    if opts[:betterifs]
      if opts[:big]
        bar.betterifs.size.should == 10
      else
        bar.betterifs.size.should >= (opts[:allow_empty] ? 0 : 1)
      end
      bar.betterifs.first.tags.is_a?(ProtocolBuffers::RepeatedField).should == true
      if bar.betterifs.first.tags.size > 0
        bar.betterifs.first.tags.first.is_a?(BetterIf::Tag).should == true
      end
      bar.betterifs.first.user.is_a?(BetterIf::User).should == true
    end
    if opts[:tags]
      if opts[:big]
        bar.tags.size.should == 10
      else
        bar.tags.size.should >= (opts[:allow_empty] ? 0 : 1)
      end
      bar.tags.is_a?(ProtocolBuffers::RepeatedField).should == true
      if bar.tags.size > 0
        bar.tags.first.is_a?(BetterIf::Tag).should == true
      end
    end
    if opts[:users]
      if opts[:big]
        bar.users.size.should == 10
      else
        bar.users.size.should >= (opts[:allow_empty] ? 0 : 1)
      end
      bar.users.is_a?(ProtocolBuffers::RepeatedField).should == true
      if bar.users.size > 0
        bar.users.first.is_a?(BetterIf::User).should == true
      end
    end
  end
end

def random_query
  'abcdefghijklmnopqrstuvwxyz'.split(//).sample
end

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
