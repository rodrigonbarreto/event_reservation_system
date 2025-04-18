# frozen_string_literal: true

class V1::ApiGrape < Grape::API
  version "v1", using: :path
  format :json
  default_format :json

  use CustomErrorMiddleware

  helpers ::Helpers::AuthHelpers

  mount V1::Events
  mount V1::Login

  add_swagger_documentation(
    api_version: "v1",
    hide_documentation_path: true,
    mount_path: "/swagger_doc",
    hide_format: true,
    info: {
      title: "Events API",
      description: "API for event management",
      contact_name: "Support Team",
      contact_email: "contact@example.com"
    },
    security_definitions: {
      Bearer: {
        type: "apiKey",
        name: "Authorization",
        in: "header",
        description: 'Enter "Bearer" followed by your token. Example: Bearer abc123'
      }
    },
    security: [{ Bearer: [] }]
  )
end
