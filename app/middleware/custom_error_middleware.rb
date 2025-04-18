# frozen_string_literal: true

class CustomErrorMiddleware < Grape::Middleware::Base
  def call(env)
    @app.call(env) # Passa a requisição adiante
  rescue Grape::Exceptions::MethodNotAllowed => e
    handle_method_not_allowed(e, env)
  rescue ActiveRecord::RecordNotFound => e
    handle_record_not_found(e)
  rescue StandardError => e
    handle_standard_error(e)
  end

  private

  def handle_record_not_found(error)
    # poude usar por exemplo Sentry.capture_exception(error, extra: { message: error.message })
    error_response(message: "Couldn't find #{error.model || 'record'} with id: #{error.id}", status: 404)
  end

  def handle_method_not_allowed(error, env)
    request_method = env["REQUEST_METHOD"]
    path = env["PATH_INFO"]

    Rails.logger.error "Method not allowed: #{request_method} for path #{path}"

    allowed_methods = if error.respond_to?(:headers) && error.headers["Allow"]
                        "Allowed methods: #{error.headers['Allow']}"
                      else
                        "Please use the appropriate HTTP methods for this endpoint"
                      end

    error_message = "The
    #{request_method} method is not allowed for this resource.
   #{allowed_methods}. please check your parameters"

    unless Rails.env.development?
      # Sentry.capture_exception(error, extra: {
      #                            request_method: request_method,
      #                            path: path,
      #                            message: error_message
      #                          })
    end

    error_response(message: error_message, status: 405)
  end

  def handle_standard_error(error)
    Rails.logger.error(error.message)
    Rails.logger.error(error.backtrace.join("\n"))
    # Sentry.capture_exception(error, extra: { message: error.message }) unless Rails.env.development?
    error_response(message: "Something went wrong", status: 500)
  end

  def error_response(message:, status:)
    throw :error, message: { error: message }, status: status
  end
end
