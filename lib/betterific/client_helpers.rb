require 'net/http'

module Betterific
  module ClientHelpers
    def get_http(uri, opts={}) #:nodoc:
      res = Net::HTTP.get_response(uri)
      unless res.is_a?(Net::HTTPSuccess)
        raise "Could not connect to #{uri}"
      end
      res
    end
  end
end
