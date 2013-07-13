require 'hashie'
require 'json'

module Betterific
  module JsonClient
    include ::Betterific::ClientConstants
    class << self
      include ::Betterific::ClientHelpers
      def get_json(url, opts={}, url_params={}) #:nodoc:
        url = add_page_params(url, page_params_from_opts(opts))
        uri = URI(url)
        unless url_params.empty?
          uri.query = URI.encode_www_form(url_params)
        end
        Hashie::Mash.new(JSON.parse(get_http(uri).body))
      end; private :get_json
    end

    # Get a list of betterifs.
    #
    # ==== Parameters
    #
    # * +opts+ - If most_popular, gets the most popular betterifs of the last
    #   week.
    #
    #   If most_recent, gets the most recent betterifs.
    #
    #   {:ids => [id0, id1, ..., idx]} specifies the ids of the betterif(s) to
    #   return.
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

    # Get a list of tags.
    #
    # ==== Parameters
    #
    # * +opts+ - {:ids => [id0, id1, ..., idx]} specifies the ids of the
    #   tag(s) to return.
    def self.tags(opts={})
      if opts[:ids]
        return get_json("#{TAGS_BASE_URL}?tags[ids]=#{Array(opts[:ids]).map(&:to_s).join(',')}")
      else
        raise "No ids given."
      end
    end

    # Get a list of users.
    #
    # ==== Parameters
    #
    # * +opts+ - {:ids => [id0, id1, ..., idx]} specifies the ids of the
    #   user(s) to return.
    def self.users(opts={})
      if opts[:ids]
        return get_json("#{USERS_BASE_URL}?users[ids]=#{Array(opts[:ids]).map(&:to_s).join(',')}")
      else
        raise "No ids given."
      end
    end

    # Search for betterifs, tags, and users.
    #
    # ==== Parameters
    #
    # * +opts+ - {:namespace => (all|betterifs|tags|users)} specifies the type
    #   of object(s) to return.
    #
    #   {:q => <query>} specifies the search query.
    def self.search(opts={})
      raise "No namespace given." if opts[:namespace].nil?
      raise "No q given." if opts[:q].nil?
      raise "q is blank." if opts[:q].blank?
      if [:betterifs, 'betterifs', :tags, 'tags', :users, 'users', :all, 'all'].include?(opts[:namespace])
        return get_json("#{SEARCH_BASE_URL}/#{opts[:namespace]}", {}, :q => opts[:q])
      else
        raise "Invalid namespace: #{opts[:namespace]}"
      end
    end
  end
end
