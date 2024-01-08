# frozen_string_literal: true

module Events
  class EventConcertForm < Events::EventFormBase
    validates :number_of_people, numericality: { greater_than: 100 }
  end
end
