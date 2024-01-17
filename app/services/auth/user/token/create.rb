# frozen_string_literal: true

class Auth::User::Token::Create < Auth::Base
  def initialize(email, password)
    @email = email
    @password = password
  end

  def user
    user = User.find_by(email: email)
    return user if user&.valid_password?(password)

    errors.add :user_authentication, 'invalid credentials'
  end
end
