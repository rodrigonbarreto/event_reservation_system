# frozen_string_literal: true

module Events
  module Interactors
    class CreateEvent
      include Interactor

      delegate :params, to: :context
      def call
        event = Event.new(context.params)

        if event.save
          context.event = event
        else
          context.fail!(errors: event.errors)
        end
      end
    end
  end
end
