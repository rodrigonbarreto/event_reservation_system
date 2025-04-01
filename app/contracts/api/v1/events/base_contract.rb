# frozen_string_literal: true

# app/contracts/api/v1/events/base_contract.rb
module Api
  module V1
    module Events
      class BaseContract < Dry::Validation::Contract
        params do
          required(:title).filled(:string)
          required(:event_type).filled(::Types::EventType)
          required(:number_of_people).filled(:integer)
          optional(:description).maybe(:string)
          optional(:special_requests).maybe(:string)
        end
      end
    end
  end
end
