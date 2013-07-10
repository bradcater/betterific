require 'json'
require 'net/http'
require 'protocol_buffers'
require 'protocol_buffers/compiler'

module Betterific
  module ProtobufClient
    include ::Betterific::ClientConstants
    class << self
      def compile_and_load_string(kode, url)
        deps = fetch_and_save_dependencies(kode, url)
        fname = url.split(/\//)[-1]
        f = File.open(fname, 'w')
        f.write(kode)
        f.close
        deps << fname
        deps = deps.reject do |d|
          Kernel.const_defined?('BetterIf'.to_sym) && BetterIf.const_defined?(d.gsub(/\.proto$/, '').camelize.to_sym)
        end
        unless deps.empty?
          ProtocolBuffers::Compiler.compile_and_load(deps, :include_dirs => ['.'])
        end
      end; private :compile_and_load_string

      def fetch_and_save_dependencies(kode, url)
        kode.scan(/import '([^']+)';/).map do |imp|
          imp = imp.first
          imp_url = [url.split(/\//)[0..-2], imp].flatten.join('/')
          puts imp_url
          uri = URI(imp_url)
          res = Net::HTTP.get_response(uri)
          if res.is_a?(Net::HTTPSuccess)
            f = File.open(imp, 'w')
            f.write(res.body)
            f.close
          end
          fetch_and_save_dependencies(res.body, url) + [imp]
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
        url = "#{url}.protobuf"
        uri = URI(url)
        unless params.empty?
          uri.query = URI.encode_www_form(params)
        end
        res = Net::HTTP.get_response(uri)
        unless res.is_a?(Net::HTTPSuccess)
          raise "Could not connect to #{uri}"
        end
        schema_url = res.header['X-Protobuf-Schema']
        schema_uri = URI(schema_url)
        schema_res = Net::HTTP.get_response(schema_uri)
        unless schema_res.is_a?(Net::HTTPSuccess)
          raise "Could not connect to #{schema_uri}"
        end
        proto_name = schema_uri.to_s.split(/\//).last
        compile_and_load_string(schema_res.body, schema_url)
        proto_klass = get_namespaced_class("BetterIf::#{proto_name.gsub(/\.proto$/, '').camelize}")
        proto_klass.parse(res.body)
      end; private :get_protobuf
    end

    def self.betterifs(opts={})
      if [:most_popular, 'most_popular'].include?(opts) || (opts.is_a?(Hash) && [:most_popular, 'most_popular'].include?(opts[:filter]))
        return get_protobuf("#{BETTERIFS_BASE_URL}/most-popular")
      elsif [:most_recent, 'most_recent'].include?(opts) || (opts.is_a?(Hash) && [:most_recent, 'most_recent'].include?(opts[:filter]))
        return get_protobuf("#{BETTERIFS_BASE_URL}/most-recent")
      end
      1
    end
  end

end

=begin
[
  ['http://localhost:3000/api/betterifs.protobuf', {'betterifs[ids]' => [16, 17, 18, 19, 20]}],
  ['http://localhost:3000/api/tags.protobuf', {'tags[ids]' => 403056}],
  ['http://localhost:3000/api/users.protobuf', {'users[ids]' => [2, 3, 4]}],
  ['http://localhost:3000/api/search/all.protobuf', {:q => 'a'}]
].each do |(url, params)|
  puts url
  uri = URI(url)
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  if res.is_a?(Net::HTTPSuccess)
    content_length = res.header['Content-Length'].to_i
    puts "Content-Length: #{content_length}"
    %w{json rss xml}.each do |alt_format|
      alt_uri = URI(url.gsub(/\.protobuf/, ".#{alt_format}"))
      alt_uri.query = URI.encode_www_form(params)
      alt_res = Net::HTTP.get_response(alt_uri)
      if alt_res.is_a?(Net::HTTPSuccess)
        alt_res_content_length = alt_res.header['Content-Length'].to_i
        puts "compare to #{alt_format.upcase} Content-Length #{alt_res_content_length} (#{(100 - (content_length.to_f / alt_res_content_length.to_f * 100.0)).round(2)}% savings)"
      end
    end
    schema_url = res.header['X-Protobuf-Schema']
    puts "schema_url: #{schema_url}"
    schema_uri = URI(schema_url)
    schema_res = Net::HTTP.get_response(schema_uri)
    if schema_res.is_a?(Net::HTTPSuccess)
      proto_name = schema_uri.to_s.split(/\//).last
      compile_and_load_string(schema_res.body, schema_url)
      proto_klass = get_namespaced_class("BetterIf::#{proto_name.gsub(/\.proto$/, '').camelize}")
      if VERBOSE
        puts "public methods:"
        puts (proto_klass.public_methods - Object.public_methods).inspect
      end
      bt = proto_klass.parse(res.body)
      puts bt.inspect
    end
  end
end
=end
