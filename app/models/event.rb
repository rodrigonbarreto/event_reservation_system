class Event < ApplicationRecord
  enum event_type: { business: 'business', birthday: 'birthday' }
end
