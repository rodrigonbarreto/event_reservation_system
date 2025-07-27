class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true

  scope :recent, -> { where('created_at > ?', 1.day.ago) }
  scope :by_user, ->(user) { where(user: user) }

  delegate :title, to: :post, prefix: true
  delegate :name, to: :user, prefix: true
end