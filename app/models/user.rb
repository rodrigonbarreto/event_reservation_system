class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_categories, through: :posts
  has_many :categories, through: :post_categories

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def published_posts
    posts.where(published: true)
  end
end