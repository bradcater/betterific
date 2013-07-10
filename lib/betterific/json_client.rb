require 'json'

module Betterific
  module JsonClient
    include ::Betterific::ClientConstants
    class << self
      include ::Betterific::ClientHelpers
      def get_json(url, params={})
        uri = URI(url)
        unless params.empty?
          uri.query = URI.encode_www_form(params)
        end
        JSON.parse(get_http(uri).body)
      end; private :get_json
    end

    def self.betterifs(opts={})
      if [:most_popular, 'most_popular'].include?(opts) || (opts.is_a?(Hash) && [:most_popular, 'most_popular'].include?(opts[:filter]))
        return get_json("#{BETTERIFS_BASE_URL}/most-popular")
      elsif [:most_recent, 'most_recent'].include?(opts) || (opts.is_a?(Hash) && [:most_recent, 'most_recent'].include?(opts[:filter]))
        return get_json("#{BETTERIFS_BASE_URL}/most-recent")
      elsif opts[:ids]
        return get_json("#{BETTERIFS_BASE_URL}?betterifs[ids]=#{Array(opts[:ids]).map(&:to_s).join(',')}")
      else
        raise "No filter and no ids given."
      end
    end
  end

end
