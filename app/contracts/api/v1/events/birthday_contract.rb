# frozen_string_literal: true

module Api
  module V1
    module Events
      class BirthdayContract < BaseContract
        params do
          # more fields can be added here
        end

        rule(:number_of_people) do
          result = Types::BirthdayPeople.try(value)
          key.failure("must be greater than 10") if result.failure?
        rescue StandardError
          key.failure("is invalid")
        end
      end
    end
  end
end
