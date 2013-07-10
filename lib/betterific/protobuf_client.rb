require 'protocol_buffers'
require 'protocol_buffers/compiler'

module Betterific
  module ProtobufClient
    include ::Betterific::ClientConstants
    class << self
      include ::Betterific::ClientHelpers
      # Cache of the last time a schema was refreshed by name.
      LAST_REFRESH = {}
      # Cache of schemas by URI.
      PROTO_SCHEMA_CACHE = {}
      # How many seconds to keep a schema before refreshing.
      PROTO_TTL_SECONDS = 60
      def compile_and_load_string(kode, url) #:nodoc
        unless Dir.exists?(self::TMP_DIR)
          Dir.mkdir(self::TMP_DIR, 0700)
        end
        deps = fetch_and_save_dependencies(kode, url)
        fname = url.split(/\//)[-1]
        File.open(File.join(self::TMP_DIR, fname), 'w') do |f|
          f.write(kode)
        end
        deps << fname
        deps = deps.reject do |d|
          Kernel.const_defined?(self::PROTO_PACKAGE_NAME.to_sym) && Kernel.const_get(self::PROTO_PACKAGE_NAME.to_sym)
            .const_defined?(d.gsub(/\.proto$/, '').camelize.to_sym)
        end
        unless deps.empty?
          ProtocolBuffers::Compiler.compile_and_load(deps.map do |d|
            File.join(self::TMP_DIR, d)
          end, :include_dirs => [self::TMP_DIR])
        end
      end; private :compile_and_load_string

      def fetch_and_save_dependencies(kode, url) #:nodoc
        kode.scan(/import\s+'([^']+)';/).map do |imp|
          imp = imp.first
          imp_url = [url.split(/\//)[0..-2], imp].flatten.join('/')
          uri = URI(imp_url)
          if LAST_REFRESH[uri].nil? || (LAST_REFRESH[uri] < Time.now - PROTO_TTL_SECONDS)
            PROTO_SCHEMA_CACHE[uri] = get_http(URI(imp_url))
            File.open(File.join(self::TMP_DIR, imp), 'w') do |f|
              f.write(PROTO_SCHEMA_CACHE[uri].body)
            end
            LAST_REFRESH[uri] = Time.now
          end
          fetch_and_save_dependencies(PROTO_SCHEMA_CACHE[uri].body, url) + [imp]
        end.flatten.uniq
      end; private :fetch_and_save_dependencies
      
      def get_namespaced_class(klass_string, o=nil) #:nodoc
        return o if klass_string == nil
        unless klass_string.is_a?(Array)
          klass_string = klass_string.split(/::/)
        end
        o ||= Kernel
        o = o.const_get(klass_string.first)
        return o if klass_string.size == 1
        get_namespaced_class(klass_string[1..-1], o)
      end; private :get_namespaced_class

      def get_protobuf(url, params={}) #:nodoc
        proto_url = if url =~ /\?/
          url.gsub(/\?/, '.protobuf?')
        else
          "#{url}.protobuf"
        end
        uri = URI(proto_url)
        unless params.empty?
          uri.query = URI.encode_www_form(params)
        end
        res = get_http(uri)
        schema_uri = URI(res.header['X-Protobuf-Schema'])
        if PROTO_SCHEMA_CACHE[schema_uri].nil? || LAST_REFRESH[schema_uri] < Time.now - PROTO_TTL_SECONDS
          PROTO_SCHEMA_CACHE[schema_uri] = get_http(schema_uri)
          LAST_REFRESH[schema_uri] = Time.now
        end
        proto_name = schema_uri.to_s.split(/\//).last
        compile_and_load_string(PROTO_SCHEMA_CACHE[schema_uri].body, schema_uri.to_s)
        proto_klass = get_namespaced_class("#{self::PROTO_PACKAGE_NAME}::#{proto_name.gsub(/\.proto$/, '').camelize}")
        proto_klass.parse(res.body)
      end; private :get_protobuf
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
        return get_protobuf("#{BETTERIFS_BASE_URL}/most-popular")
      elsif [:most_recent, 'most_recent'].include?(opts) || (opts.is_a?(Hash) && [:most_recent, 'most_recent'].include?(opts[:filter]))
        return get_protobuf("#{BETTERIFS_BASE_URL}/most-recent")
      elsif opts[:ids]
        return get_protobuf("#{BETTERIFS_BASE_URL}?betterifs[ids]=#{Array(opts[:ids]).map(&:to_s).join(',')}")
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
        return get_protobuf("#{TAGS_BASE_URL}?tags[ids]=#{Array(opts[:ids]).map(&:to_s).join(',')}")
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
        return get_protobuf("#{USERS_BASE_URL}?users[ids]=#{Array(opts[:ids]).map(&:to_s).join(',')}")
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
        return get_protobuf("#{SEARCH_BASE_URL}/#{opts[:namespace]}?q=#{opts[:q]}")
      else
        raise "Invalid namespace: #{opts[:namespace]}"
      end
    end
  end
end
