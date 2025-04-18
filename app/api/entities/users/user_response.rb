# frozen_string_literal: true

module Entities
  module Users
    class UserResponse < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "User id" }
      expose :email, documentation: { type: "String", desc: "User email" }
    end
  end
end
