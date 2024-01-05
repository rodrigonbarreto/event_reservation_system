# frozen_string_literal: true

module Events
  class EventBirthdayForm < Events::EventFormBase
    validates :number_of_people, numericality: { greater_than: 10 }
  end
end
