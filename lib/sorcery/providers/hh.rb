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

      def get_user_hash(access_token)
        user_hash = auth_hash(access_token)

        headers = { authorization: "Bearer #{access_token.token}" }
        response = access_token.get(user_info_url, headers: headers)

        user_hash[:uid] = user_hash[:user_info]["id"] if user_hash[:user_info] = JSON.parse(response.body)

        user_hash
      end

      def login_url(params, session)
        authorize_url({ authorize_url: auth_path })
      end

      def process_callback(params, session)
        args = {}.tap do |a|
          a[:code] = params[:code] if params[:code]
        end

        get_access_token(args, token_url: token_path, token_method: :post)
      end
    end
  end
end
