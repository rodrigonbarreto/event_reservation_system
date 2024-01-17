class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable

  before_save :generate_uuid
  before_create :generate_uuid

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
