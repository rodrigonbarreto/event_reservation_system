# frozen_string_literal: true

module V1
  class Events < Grape::API
    helpers do
      def event_params
        ActionController::Parameters.new(params).permit(
          :title,
          :description,
          :event_type,
          :number_of_people,
          :special_requests
        )
      end

      def find_event
        @event = Event.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        error!({ error: "Event not found" }, 404)
      end
    end

    resource :events do
      desc "Get all events", {
        success: ::Entities::EventResponse,
        failure: [
          { code: 401, message: "Unauthorized" }
        ],
        tags: ["events"]
      }
      get do
        @events = Event.all
        present @events, with: ::Entities::EventResponse
      end

      desc "Get a specific event", {
        success: ::Entities::EventResponse,
        failure: [
          { code: 401, message: "Unauthorized" },
          { code: 404, message: "Not Found" }
        ],
        tags: ["events"]
      }
      params do
        requires :id, type: Integer, desc: "Event ID"
      end
      get ":id" do
        find_event
        present @event, with: ::Entities::EventResponse
      end

      desc "Create a new event", {
        success: ::Entities::EventResponse,
        failure: [
          { code: 401, message: "Unauthorized" },
          { code: 422, message: "Unprocessable Entity" }
        ],
        tags: ["events"]
      }
      params do
        requires :title, type: String, desc: "Event title"
        requires :event_type, type: String, values: %w[business birthday], desc: "Event type"
        optional :description, type: String, desc: "Event description"
        optional :number_of_people, type: Integer, desc: "Number of attendees"
        optional :special_requests, type: String, desc: "Special requests"
      end
      post do
        @event = Event.new(event_params)
        if @event.save
          present @event, with: ::Entities::EventResponse
        else
          error!({ errors: @event.errors.full_messages }, 422)
        end
      end

      desc "Update an existing event", {
        success: ::Entities::EventResponse,
        failure: [
          { code: 401, message: "Unauthorized" },
          { code: 404, message: "Not Found" },
          { code: 422, message: "Unprocessable Entity" }
        ],
        tags: ["events"]
      }
      params do
        requires :id, type: Integer, desc: "Event ID"
        optional :title, type: String, desc: "Event title"
        optional :event_type, type: String, values: %w[business birthday], desc: "Event type"
        optional :description, type: String, desc: "Event description"
        optional :number_of_people, type: Integer, desc: "Number of attendees"
        optional :special_requests, type: String, desc: "Special requests"
      end
      put ":id" do
        find_event
        if @event.update(event_params)
          present @event, with: ::Entities::EventResponse
        else
          error!({ errors: @event.errors.full_messages }, 422)
        end
      end

      desc "Delete an event", {
        failure: [
          { code: 401, message: "Unauthorized" },
          { code: 404, message: "Not Found" }
        ],
        tags: ["events"]
      }
      params do
        requires :id, type: Integer, desc: "Event ID"
      end
      delete ":id" do
        find_event
        if @event.destroy
          { success: true, message: "Event successfully deleted" }
        else
          error!({ errors: @event.errors.full_messages }, 422)
        end
      end
    end
  end
end
