# app/interactors/events/organizers/register.rb
# frozen_string_literal: true

module Events
  module Organizers
    class Register
      include Interactor::Organizer

      organize ::Events::Interactors::CreateEvent,
               ::Events::Interactors::SendNotification

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
          raise ActiveRecord::Rollback if context.failure?
        end
      end
    end
  end
end
