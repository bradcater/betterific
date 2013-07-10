require 'betterific/client_constants'
require 'betterific/client_helpers'
require 'betterific/ruby_extensions'
require 'betterific/version'

require 'betterific/json_client'
begin
  require 'betterific/protobuf_client'
rescue
  puts 'Install the ruby-protocol-buffers gem to use Betterific::ProtobufClient.'
end

module Betterific
  def self.version_string
    "Betterific version #{Betterific::VERSION}"
  end
end
