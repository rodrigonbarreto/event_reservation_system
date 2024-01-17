class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  rescue_from ActionDispatch::Http::Parameters::ParseError do |_exception|
    render json: { error: 'something happens', status: :bad_request }
  end
  def authenticate_request
    auth = Authorization::User::AuthorizeApiRequestUser.call(request.headers)
    @current_user = auth.result
    render json: { errors: auth.errors }, status: :unauthorized unless @current_user
  end
end
