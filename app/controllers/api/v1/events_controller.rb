# frozen_string_literal: true

module Api
  module V1
    class EventsController < ApplicationController
      def create
        begin
          contract = ::ContractFactory.for(event_params)
          result = contract.call(event_params)
        rescue ::ContractFactory::InvalidEventTypeError => e
          return render json: { error: e.message }, status: :bad_request
        end

        if result.success?
          create_event(result.to_h)
        else
          render json: { errors: result.errors.to_h }, status: :unprocessable_entity
        end
      end

      private

      def create_event(attributes)
        event = Event.new(attributes)
        if event.save
          render json: event, status: :created
        else
          render json: event.errors, status: :unprocessable_entity
        end
      end

      def event_params
        params.require(:event).permit(:title, :description, :event_type, :number_of_people, :special_requests).to_h
      end
    end
  end
end
