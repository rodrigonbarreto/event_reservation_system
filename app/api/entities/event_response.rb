# frozen_string_literal: true

module Entities
  class EventResponse < Grape::Entity
    expose :id, documentation: { type: "Integer", desc: "Event ID" }
    expose :title, documentation: { type: "String", desc: "Event Title" }
    expose :description, documentation: { type: "String", desc: "Event Description" }
    expose :event_type, documentation: { type: "String", desc: "Event Type" }
    expose :number_of_people, documentation: { type: "Integer", desc: "Number of People" }
    expose :special_requests, documentation: { type: "String", desc: "Special Requests" }
  end
end
