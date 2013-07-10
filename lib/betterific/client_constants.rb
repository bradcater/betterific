module Betterific
  module ClientConstants
    # The base URL for the Betterific API.
    BASE_URL = 'http://localhost:3000/api'.freeze
    #BASE_URL = 'http://betterific.com/api'.freeze #:nodoc:

    # The base URL to GET betterifs.
    BETTERIFS_BASE_URL = "#{BASE_URL}/betterifs".freeze
    # The base URL to GET tags.
    TAGS_BASE_URL = "#{BASE_URL}/tags".freeze
    # The base URL to GET users.
    USERS_BASE_URL = "#{BASE_URL}/users".freeze

    # The base URL to GET search results.
    SEARCH_BASE_URL = "#{BASE_URL}/search".freeze

    # The package in which protocol buffer schemas are defined.
    PROTO_PACKAGE_NAME = 'BetterIf'.freeze

    # The directory in which to store temporary files.
    TMP_DIR = File.expand_path(File.join('.', 'tmp'))
  end
end
