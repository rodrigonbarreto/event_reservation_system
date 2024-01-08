# frozen_string_literal: true

module Events
  class EventFormBase
    include ActiveModel::Model

    attr_accessor :title, :description, :event_type, :number_of_people, :special_requests

    validates :title, :event_type, :number_of_people, presence: true

    def attributes
      {
        title:,
        description:,
        event_type:,
        number_of_people:,
        special_requests:
      }
    end

    def create
      return false unless valid?

      event = Event.new(attributes)
      event.save!
    end
  end
end
