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

    def self.tags(opts={})
      if opts[:ids]
        return get_json("#{TAGS_BASE_URL}?tags[ids]=#{Array(opts[:ids]).map(&:to_s).join(',')}")
      else
        raise "No ids given."
      end
    end

    def self.users(opts={})
      if opts[:ids]
        return get_json("#{USERS_BASE_URL}?users[ids]=#{Array(opts[:ids]).map(&:to_s).join(',')}")
      else
        raise "No ids given."
      end
    end

    def self.search(opts={})
      raise "No namespace given." if opts[:namespace].nil?
      raise "No q given." if opts[:q].nil?
      raise "q is blank." if opts[:q].blank?
      if [:betterifs, 'betterifs', :tags, 'tags', :users, 'users', :all, 'all'].include?(opts[:namespace])
        return get_json("#{SEARCH_BASE_URL}/#{opts[:namespace]}?q=#{opts[:q]}")
      else
        raise "Invalid namespace: #{opts[:namespace]}"
      end
    end
  end
end
