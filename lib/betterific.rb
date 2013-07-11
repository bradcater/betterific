require 'betterific/client_constants'
require 'betterific/client_helpers'
require 'betterific/ruby_extensions'
require 'betterific/version'

require 'betterific/json_client'
if Gem::Specification.find_all_by_name('ruby-protocol-buffers').any?
  require 'betterific/protobuf_client'
else
  puts 'Betterific: Install the ruby-protocol-buffers gem to use Betterific::ProtobufClient.'
end

module Betterific
  # See a human-readable form of this gem's current version.
  #
  def self.version_string
    "Betterific version #{Betterific::VERSION}"
  end
end
