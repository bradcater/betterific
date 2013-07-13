module Betterific
  module Client
    # Delegate all methods to a client implementation if that client
    # implementation supports the method. Use ProtobufClient if it's
    # available; otherwise, use JsonClient.
    #
    CLIENT = if defined?(Betterific::ProtobufClient)
      Betterific::ProtobufClient
    else
      Betterific::JsonClient
    end
    
    def self.respond_to?(method) #:nodoc:
      return true if CLIENT.respond_to?(method)
      super
    end
    def self.method_missing(method, *args, &block) #:nodoc:
      if CLIENT.respond_to?(method)
        return CLIENT.send(method, *args, &block)
      end
      super
    end
  end
end
