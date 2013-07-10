require 'net/http'

module Betterific
  module ClientHelpers
    def get_http(uri, opts={}) #:nodoc:
      res = Net::HTTP.get_response(uri)
      unless res.is_a?(Net::HTTPSuccess)
        raise "Could not connect to #{uri}"
      end
      res
    end; private :get_http

    def add_page_params(url, opts={}) #:nodoc:
      to_add = []
      if opts[:page]
        unless valid_page_param?(opts[:page])
          raise "Invalid page: #{opts[:page]}"
        end
        to_add << "page=#{opts[:page]}"
      end
      if opts[:per_page]
        unless valid_page_param?(opts[:per_page])
          raise "Invalid per_page: #{opts[:per_page]}"
        end
        to_add << "per_page=#{opts[:per_page]}"
      end
      if to_add.size > 0
        url = "#{url}#{url =~ /\?/ ? '&' : '?'}#{to_add.join('&')}"
      end
      url
    end; private :add_page_params

    def page_params_from_opts(opts) #:nodoc:
      return {} unless opts.is_a?(Hash)
      [:page, :per_page].inject({}) do |hsh, k|
        hsh[k] = opts[k]
        hsh
      end
    end; private :page_params_from_opts

    def valid_page_param?(p) #:nodoc:
      p.is_a?(Fixnum) && p > 0 && p.to_i == p
    end; private :valid_page_param?
  end
end
