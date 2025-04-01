# frozen_string_literal: true

module Api
  module V1
    module Events
      class BusinessContract < BaseContract
        params do
          optional(:company_name).maybe(:string)
        end

        rule(:number_of_people) do
          result = Types::BusinessPeople.try(value)
          key.failure("must be greater than 5") if result.failure?
        rescue StandardError
          key.failure("is invalid")
        end
      end
    end
  end
end
