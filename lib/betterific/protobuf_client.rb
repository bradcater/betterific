require 'protocol_buffers'
require 'protocol_buffers/compiler'

module Betterific
  module ProtobufClient
    include ::Betterific::ClientConstants
    class << self
      include ::Betterific::ClientHelpers
      def compile_and_load_string(kode, url)
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

      def fetch_and_save_dependencies(kode, url)
        kode.scan(/import\s+'([^']+)';/).map do |imp|
          imp = imp.first
          imp_url = [url.split(/\//)[0..-2], imp].flatten.join('/')
          uri = URI(imp_url)
          imp_content = get_http(URI(imp_url)).body
          File.open(File.join(self::TMP_DIR, imp), 'w') do |f|
            f.write(imp_content)
          end
          fetch_and_save_dependencies(imp_content, url) + [imp]
        end.flatten.uniq
      end; private :fetch_and_save_dependencies
      
      def get_namespaced_class(klass_string, o=nil)
        return o if klass_string == nil
        unless klass_string.is_a?(Array)
          klass_string = klass_string.split(/::/)
        end
        o ||= Kernel
        o = o.const_get(klass_string.first)
        return o if klass_string.size == 1
        get_namespaced_class(klass_string[1..-1], o)
      end; private :get_namespaced_class

      def get_protobuf(url, params={})
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
        schema_res = get_http(schema_uri)
        proto_name = schema_uri.to_s.split(/\//).last
        compile_and_load_string(schema_res.body, schema_uri.to_s)
        proto_klass = get_namespaced_class("#{self::PROTO_PACKAGE_NAME}::#{proto_name.gsub(/\.proto$/, '').camelize}")
        proto_klass.parse(res.body)
      end; private :get_protobuf
    end

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

    def self.tags(opts={})
      if opts[:ids]
        return get_protobuf("#{TAGS_BASE_URL}?tags[ids]=#{Array(opts[:ids]).map(&:to_s).join(',')}")
      else
        raise "No ids given."
      end
    end

    def self.users(opts={})
      if opts[:ids]
        return get_protobuf("#{USERS_BASE_URL}?users[ids]=#{Array(opts[:ids]).map(&:to_s).join(',')}")
      else
        raise "No ids given."
      end
    end
  end
end
