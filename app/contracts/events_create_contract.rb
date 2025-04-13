# frozen_string_literal: true

class EventsCreateContract < Dry::Validation::Contract
  params do
    # @title = Título do evento, com no mínimo 3 caracteres
    required(:title).filled(:string, min_size?: 3)

    # @description = Descrição detalhada do evento
    optional(:description).maybe(:string)

    # @event_type = Tipo de evento (business ou birthday)
    required(:event_type).filled(:string, included_in?: %w[business birthday])

    # @number_of_people = Número esperado de participantes
    optional(:number_of_people).maybe(:integer, gt?: 0)

    # @special_requests = Quaisquer requisitos especiais para o evento
    optional(:special_requests).maybe(:string)
  end

  rule(:number_of_people) do
    key.failure("must be provided for business events") if values[:event_type] == "business" && value.nil?
  end
end