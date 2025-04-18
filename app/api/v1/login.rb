# frozen_string_literal: true

module V1
  class Login < Grape::API
    resource :login do
      desc "Login ", {
        success: Entities::Users::LoginResponse,
        failure: [{ code: 401, message: "Unauthorized" }],
        params: ::Helpers::ContractToParams.generate_params(LoginContract)
      }
      post do
        contract = LoginContract.new
        result = contract.call(params)
        error!({ errors: result.errors.to_h }, 422) if result.failure?

        @user = User.find_by(email: params[:email])
        if @user&.valid_password?(params[:password])
          token = ::Jwt::JsonWebToken.encode({ id: @user.id })
          status 200
          present({ user: @user, token: token }, with: Entities::Users::LoginResponse)
        else
          error!({ error: "Unauthorized" }, 401)
        end
      end
    end
  end
end
