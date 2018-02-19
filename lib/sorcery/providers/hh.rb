require 'sorcery/providers/base'

module Sorcery
  module Providers
    # This class adds support for OAuth with hh.ru.
    #
    #   config.hh.key = <key>
    #   config.hh.secret = <secret>
    #   ...
    #
    class Hh < Base
      include Protocols::Oauth2

      attr_accessor :auth_path, :token_path, :user_info_url, :scope, :response_type

      def initialize
        super

        @scope          = nil
        @site           = 'https://hh.ru/'
        @user_info_url  = 'http://api.hh.ru/me'
        @auth_path      = '/oauth/authorize'
        @token_path     = '/oauth/token'
        @grant_type     = 'authorization_code'
      end

      def process_callback(params, session)
        args = {}.tap do |a|
          a[:code] = params[:code] if params[:code]
        end
      end
    end
  end
end
