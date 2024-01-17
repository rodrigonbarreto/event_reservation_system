# frozen_string_literal: true
# app/services/auth/user/token/destroy.rb
class Auth::User::Token::Destroy < Auth::Base
  attr_reader :token, :user_id

  def initialize(token, user_id)
    @token = token
    @user_id = user_id
  end

  def call
    destroy_token if user
  end

  def user
    @user ||= User.where(uuid: @user_id, token: http_auth_header)&.first
    errors.add(:invalid_token, 'invalid Token') if @user.blank?
    @user
  end

  def destroy_token
    return errors if @user.blank?

    @user.update(token: "")
  end

  def http_auth_header
    return @token.split.last if @token.present?

    errors.add(:token, 'missing token')

    nil
  end
end
