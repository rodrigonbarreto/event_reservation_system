# frozen_string_literal: true

module Entities
  module Users
    class LoginResponse < Grape::Entity
      expose :user, using: Entities::Users::UserResponse,
                    documentation: { type: "Array", desc: "List of users" }
      expose :token, documentation: { type: "String", desc: "JWT token" }
    end
  end
end
