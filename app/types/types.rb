# frozen_string_literal: true

# app/types/types.rb
require "dry-types"

module Types
  include Dry.Types()

  # Types for specific number of people for each event type
  BirthdayPeople = Integer.constrained(gt: 10)
  BusinessPeople = Integer.constrained(gt: 5)

  # Specific type for valid event types
  EventType = String.enum("birthday", "business")
end
