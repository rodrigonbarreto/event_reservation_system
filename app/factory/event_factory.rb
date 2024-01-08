
# frozen_string_literal: true
    class EventFactory < BaseFactory
      class InvalidEventTypeError < StandardError; end
      attr_accessor :action, :params

      def initialize(action:, params:)
        @action = action
        @params = params
      end

      def call
        action_service = events[action]
        raise InvalidEventTypeError unless action_service

        action_service.new(**params)
      end

      private

      def events
        {
          "birthday": Events::EventBirthdayForm,
          "business": Events::EventBusinessForm,
          "concert": Events::EventConcertForm,
        }
      end
end
