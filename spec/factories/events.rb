# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title { "Event Title" }
    description { "Event Description" }
    event_type { "business" }
    number_of_people { 5 }
    special_requests { "Event Special Requests" }

    trait :business do
      event_type { "business" }
    end

    trait :birthday do
      event_type { "birthday" }
    end
  end
end