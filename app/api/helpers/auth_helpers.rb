# frozen_string_literal: true

module Helpers
  module AuthHelpers
    extend Grape::API::Helpers

    # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
    def authenticate_request!
      # este exemplo abaixo é so um exemplo pro POST eu basicamente no meu projeto uso apenas  headers["Authorization"]
      token = headers["Authorization"]&.split&.last || headers["authorization"]&.split&.last
      error!({ error: "Unauthorized", success: false }, 401) unless token

      # Decodifica o token JWT
      @jwt_result = Jwt::JsonWebToken.decode(token)
      error!({ error: "Invalid Token", success: false }, 401) unless @jwt_result

      # Busca o usuário atual (ou gera erro se não for encontrado)
      current_user!
    rescue StandardError => e
      error!({ error: "Authentication Error: #{e.message}" }, 401)
    end

    # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

    # este metodo busca o usuario atual e gera erro se não for encontrado
    def current_user!
      @current_user ||= User.find_by(id: @jwt_result["id"])
      error!({ error: "Invalid Token", success: false }, 401) unless @current_user
      @current_user
    end

    # este metodo me permite usar o current_user em qualquer lugar
    def current_user
      @current_user
    end
  end
end
