# app/api/v1/events.rb
# frozen_string_literal: true

module V1
  class Events < Grape::API
    before { authenticate_request! }
    # este é um exemplo apenas pro post, recomendo planejar melhor e criar algo como
    # FormatErrorHelpers e chamando
    # helpers ::Helpers::FormatErrorHelpers
    helpers do
      def format_errors(errors)
        case errors
        when ActiveModel::Errors
          errors.messages.transform_values { |messages| messages.join(", ") }
        when Hash
          errors
        else
          { base: errors.to_s }
        end
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
        params: {
          id: { type: Integer, desc: "Event ID" }
        },
        tags: ["events"]
      }
      get ":id" do
        @event = Event.find(params[:id])
        present @event, with: ::Entities::EventResponse
      end

      desc "Create a new event", {
        success: ::Entities::EventResponse,
        failure: [
          { code: 401, message: "Unauthorized" },
          { code: 422, message: "Unprocessable Entity" }
        ],
        params: ::Helpers::ContractToParams.generate_params(EventsCreateContract)
      }
      post do
        contract = EventsCreateContract.new
        result = contract.call(params)
        error!({ errors: result.errors.to_h }, 422) if result.failure?

        service_result = ::Events::Organizers::Register.call(params: result.to_h)

        if service_result.success?
          present service_result.event, with: ::Entities::EventResponse, status: :created
        else
          error!({ errors: format_errors(service_result.errors) }, 422)
        end
      end

      desc "Update an existing event", {
        success: ::Entities::EventResponse,
        failure: [
          { code: 401, message: "Unauthorized" },
          { code: 404, message: "Not Found" },
          { code: 422, message: "Unprocessable Entity" }
        ],
        params: ::Helpers::ContractToParams.generate_params(EventsUpdateContract),
        # Mesmo que os campos sejam praticamente os mesmos, a gente sabe que os detalhes fazem toda a diferença!
        # Recomendo usar o EventsUpdateContract – repetindo os campos do EventsCreateContract, nem tudo precisa ser 100% DRY (Don't Repeat Yourself).
        # E isso vale para os DTOs (sim, nossos contracts também!).
        # Mas fique à vontade para usar herança ou módulos para evitar repetir os campos; o importante é que você e sua equipe entrem em acordo e se divirtam.
        #
        # Ah, e se vocês tiverem curiosidade sobre por que eu não uso abstração em DTOs... quem sabe a gente discute isso num próximo post!
        tags: ["events"]
      }
      put ":id" do
        contract = EventsUpdateContract.new
        result = contract.call(params)
        error!({ errors: result.errors.to_h }, 422) if result.failure?

        @event = ::Event.find(params[:id])
        @event.assign_attributes(result.to_h)

        if @event.save
          present @event, with: ::Entities::EventResponse
        else
          error!({ errors: format_errors(@event.errors) }, 422)
        end
      rescue ActiveRecord::RecordNotFound
        error!({ error: "Event not found" }, 404)
      end

      desc "Delete an event", {
        failure: [
          { code: 401, message: "Unauthorized" },
          { code: 404, message: "Not Found" }
        ],
        params: {
          id: { type: Integer, desc: "Event ID" }
        },
        tags: ["events"]
      }
      delete ":id" do
        @event = Event.find(params[:id])

        if @event.destroy
          { success: true, message: "Event successfully deleted" }
        else
          error!({ errors: format_errors(@event.errors) }, 422)
        end
      rescue ActiveRecord::RecordNotFound
        error!({ error: "Event not found" }, 404)
      end
    end
  end
end
