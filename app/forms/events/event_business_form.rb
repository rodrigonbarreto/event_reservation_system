# frozen_string_literal: true

module Events
  class EventBusinessForm < Events::EventFormBase
    validates :number_of_people, numericality: { greater_than: 5 }
  end
end
