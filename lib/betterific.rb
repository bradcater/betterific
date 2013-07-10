require 'betterific/ruby_extensions'
require 'betterific/version'

module Betterific
  def self.version_string
    "Betterific version #{Betterific::VERSION}"
  end
end
