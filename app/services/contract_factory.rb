# frozen_string_literal: true

class ContractFactory
  class InvalidEventTypeError < StandardError; end
  INVALID_EVENT_TYPE_MSG = "Invalid event type"

  def self.for(params)
    case params[:event_type]
    when Event.event_types[:birthday]
      ::Api::V1::Events::BirthdayContract.new
    when Event.event_types[:business]
      ::Api::V1::Events::BusinessContract.new
    else
      raise InvalidEventTypeError, INVALID_EVENT_TYPE_MSG
    end
  end
end
