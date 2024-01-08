# frozen_string_literal: true

module Api
  module V1
    class EventsController < ApplicationController
      INVALID_EVENT_TYPE_MSG = 'Invalid event type'

      def create
        form = EventFactory.call(action: event_params[:event_type].to_sym, params: event_params)

        if form.create
          render json: form, status: :created
        else
          render json: form.errors, status: :unprocessable_entity
        end
      rescue EventFactory::InvalidEventTypeError => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      def event_params
        params.require(:event).permit(:title, :description, :event_type, :number_of_people, :special_requests)
      end
    end
  end
end
