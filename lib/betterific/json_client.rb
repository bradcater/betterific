require 'json'
require 'net/http'

module Betterific
  module JsonClient
    include ::Betterific::ClientConstants
    class << self
      def get_json(url, params={})
        uri = URI(url)
        unless params.empty?
          uri.query = URI.encode_www_form(params)
        end
        res = Net::HTTP.get_response(uri)
        unless res.is_a?(Net::HTTPSuccess)
          raise "Could not connect to #{uri}"
        end
        JSON.parse(res.body)
      end; private :get_json
    end

    def self.betterifs(opts={})
      if [:most_popular, 'most_popular'].include?(opts) || (opts.is_a?(Hash) && [:most_popular, 'most_popular'].include?(opts[:filter]))
        return get_json("#{BETTERIFS_BASE_URL}/most-popular")
      elsif [:most_recent, 'most_recent'].include?(opts) || (opts.is_a?(Hash) && [:most_recent, 'most_recent'].include?(opts[:filter]))
        return get_json("#{BETTERIFS_BASE_URL}/most-recent")
      end
      1
    end
  end

end
