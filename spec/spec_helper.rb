require 'betterific'
require 'betterific/client_constants'
require 'betterific/json_client'

begin
  require 'betterific/protobuf_client'
rescue
  puts 'Install the ruby-protocol-buffers gem to use Betterific::ProtobufClient.'
end

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
