# frozen_string_literal: true

module Events
  module Interactors
    class SendNotification
      include Interactor

      delegate :event, to: :context
      def call
        Rails.logger.info("Evento '#{event.title}' foi criado com sucesso!")

        # Aqui você poderia enviar uma notificação real via email, SMS, etc.
        # Para fins de demonstração, estamos apenas registrando uma mensagem
      end
    end
  end
end
