# frozen_string_literal: true


module Authorization
  module User
    class AuthorizeApiRequestUser < Common::ApplicationService

      attr_reader :headers

      def initialize(headers = {})
        @headers = headers
      end

      def call
        user
      end

      private

      def decoded_auth_token
        @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
      end

      def http_auth_header
        return headers['Authorization'].split.last if headers['Authorization'].present?

        errors.add(:token, 'missing token')

        nil
      end

      def user
        @user ||= ::User.find_by(uuid: decoded_auth_token[:uuid], token: http_auth_header) if decoded_auth_token
        @user || (errors.add(:token, 'invalid token of user') && nil)
      end
    end
  end
end

