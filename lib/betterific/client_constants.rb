module Betterific
  module ClientConstants
    #BASE_URL = 'http://betterific.com/api'.freeze
    BASE_URL = 'http://localhost:3000/api'.freeze

    BETTERIFS_BASE_URL = "#{BASE_URL}/betterifs".freeze
    TAGS_BASE_URL = "#{BASE_URL}/tags".freeze
    USERS_BASE_URL = "#{BASE_URL}/users".freeze

    PROTO_PACKAGE_NAME = 'BetterIf'.freeze
    TMP_DIR = File.expand_path(File.join('.', 'tmp'))
  end
end
