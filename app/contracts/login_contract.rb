# frozen_string_literal: true

class LoginContract < Dry::Validation::Contract
  params do
    # @email = email para login!!
    required(:email).filled(:string)
    required(:password).filled(:string)
  end
end
