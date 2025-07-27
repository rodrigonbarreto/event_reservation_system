class PostCategory < ApplicationRecord
  belongs_to :post
  belongs_to :category

  scope :for_published_posts, -> { joins(:post).where(posts: { published: true }) }
  scope :recent, -> { where('created_at > ?', 1.week.ago) }
end
