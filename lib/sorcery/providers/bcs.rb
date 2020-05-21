require 'sorcery/providers/base'

module Sorcery
  module Providers
    # This class adds support for OAuth with hh.ru.
    #
    #   config.bcs.key = <key>
    #   config.bcs.secret = <secret>
    #   ...
    #
    class Bcs < Base
      include Protocols::Oauth2

      attr_accessor :auth_path, :token_path, :user_info_url, :scope, :response_type

      def initialize
        super

        @scope          = nil
        @site           = 'https://studytrade.net'
        @user_info_url  = 'https://studytrade.net/oauth/resource/name'
        @auth_path      = ''
        @token_path     = '/oauth/token'
        @grant_type     = 'authorization_code'
      end

      def get_user_hash(access_token)
        response = access_token.get(user_info_url)

        auth_hash(access_token).tap do |h|
          h[:user_info] = JSON.parse(response.body)
          h[:uid] = h.dig(:user_info, "uid")
        end
      end

      def login_url(params, session)
        authorize_url(authorize_url: auth_path)
      end

      def process_callback(params, _session)
        args = {}.tap do |a|
          a[:code] = params[:code] if params[:code]
        end

        get_access_token(args, token_url: token_path, mode: :query, param_name: :access_token)
      end
    end
  end
end
