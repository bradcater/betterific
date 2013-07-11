module Betterific
  module Client
    CLIENT = if defined?(Betterific::ProtobufClient)
      Betterific::ProtobufClient
    else
      Betterific::JsonClient
    end
    
    def self.respond_to?(method)
      return true if CLIENT.respond_to?(method)
      super
    end
    def self.method_missing(method, *args, &block)
      if CLIENT.respond_to?(method)
        return CLIENT.send(method, *args, &block)
      end
      super
    end
  end
end
