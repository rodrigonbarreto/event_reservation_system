# frozen_string_literal: true

module Events
  class EventFormBase
    include ActiveModel::Model

    attr_accessor :title, :description, :event_type, :number_of_people, :special_requests

    validates :title, :event_type, :number_of_people, presence: true

    def attributes
      {
        title: title,
        description: description,
        event_type: event_type,
        number_of_people: number_of_people,
        special_requests: special_requests
      }
    end
    #
    # def create
    #   Event.create!(attributes)
    # end
  end
end
