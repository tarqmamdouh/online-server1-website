require 'digest/md5'

module Devise
  module Encryptable
    module Encryptors
      class CustomAuthentication < Base
        def self.digest(password, stretches, salt, pepper)
          string_to_hash = "#{password}"
          Digest::MD5.hexdigest(string_to_hash)
        end
      end
    end
  end
end