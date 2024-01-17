class SessionController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    auth = Auth::User::Token::Create.call(params["email"], params["password"])
    if auth.success?
      uuid = ::JsonWebToken.decode(auth.result)["uuid"]
      user = User.find_by(uuid: uuid)
      render json: user, except: [:created_at, :updated_at, :id], status: :ok
    else
      render json: { errors: auth.errors }, status: :unauthorized
    end
  end

  def destroy
    auth = Auth::User::Token::Destroy.call(request.headers['Authorization'], User.first.uuid)
    if auth.success?
      render json: { message: auth.result }
    else
      render json: { errors: auth.errors }, status: :unauthorized
    end
  end
end
