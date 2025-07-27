class Category < ApplicationRecord
  has_many :post_categories, dependent: :destroy
  has_many :posts, through: :post_categories
  has_many :users, through: :posts

  validates :name, presence: true, uniqueness: true

  scope :with_published_posts, -> { joins(:posts).where(posts: { published: true }).distinct }

  def published_posts_count
    posts.where(published: true).count
  end
end