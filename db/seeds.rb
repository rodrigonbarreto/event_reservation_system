# db/seeds.rb
puts "🌱 Starting seed process..."

# Clean existing data (be careful in production!)
puts "🧹 Cleaning existing data..."
Comment.destroy_all
PostCategory.destroy_all
Post.destroy_all
Category.destroy_all
User.destroy_all

puts "👥 Creating users..."
users = [
  {
    name: "John Smith",
    email: "john@example.com",
    bio: "Ruby on Rails developer for 5 years, passionate about clean code and best practices."
  },
  {
    name: "Sarah Johnson",
    email: "sarah@example.com",
    bio: "Tech Lead and mentor, specialist in system architecture and performance optimization."
  },
  {
    name: "Mike Wilson",
    email: "mike@example.com",
    bio: "Full-stack developer who loves sharing knowledge about web development."
  },
  {
    name: "Emma Davis",
    email: "emma@example.com",
    bio: "DevOps engineer and agile methodologies evangelist."
  },
  {
    name: "Alex Rodriguez",
    email: "alex@example.com",
    bio: "Senior developer focused on APIs and microservices architecture."
  }
]


created_users = users.map do |user_data|
  User.create!(user_data)
end
puts "✅ Created #{created_users.count} users"

puts "📂 Creating categories..."
categories_data = [
  {
    name: "Ruby on Rails",
    description: "Articles about Ruby on Rails framework, gems, patterns and best practices."
  },
  {
    name: "Performance",
    description: "Query optimization, caching, profiling and performance techniques."
  },
  {
    name: "Testing",
    description: "TDD, BDD, RSpec, integration testing and testing strategies."
  },
  {
    name: "DevOps",
    description: "Deployment, CI/CD, containerization and infrastructure as code."
  },
  {
    name: "JavaScript",
    description: "Frontend development, APIs, JS frameworks and Rails integration."
  },
  {
    name: "Database",
    description: "PostgreSQL, MySQL, migrations, modeling and database optimization."
  },
  {
    name: "Architecture",
    description: "Design patterns, SOLID principles, microservices and software architecture."
  }
]

created_categories = categories_data.map do |category_data|
  Category.create!(category_data)
end
puts "✅ Created #{created_categories.count} categories"

puts "📝 Creating posts..."
posts_data = [
  {
    title: "Complete Guide to Active Record Queries",
    content: "In this article, we'll explore best practices for Active Record queries. From basics to advanced optimization techniques...",
    published: true,
    user: created_users.sample
  },
  {
    title: "Avoiding the N+1 Problem in Rails",
    content: "The N+1 problem is one of the biggest performance villains in Rails applications. Let's see how to identify and solve it...",
    published: true,
    user: created_users.sample
  },
  {
    title: "TDD with RSpec: From Basic to Advanced",
    content: "Test-Driven Development is fundamental for quality code. This tutorial shows how to implement TDD using RSpec...",
    published: true,
    user: created_users.sample
  },
  {
    title: "Deploying Rails Apps with Docker",
    content: "Containerization greatly facilitates deployment and scalability. Let's see how to dockerize a Rails app from scratch...",
    published: true,
    user: created_users.sample
  },
  {
    title: "Optimizing SQL Query Performance",
    content: "Slow queries can break your application. This guide shows techniques to identify and optimize database queries...",
    published: true,
    user: created_users.sample
  },
  {
    title: "Hotwire: The Future of Rails Frontend",
    content: "Hotwire revolutionizes how we build reactive interfaces in Rails. Let's explore Turbo and Stimulus...",
    published: true,
    user: created_users.sample
  },
  {
    title: "Microservices with Rails: Pros and Cons",
    content: "When is it worth breaking a Rails monolith into microservices? Complete analysis of trade-offs...",
    published: false,
    user: created_users.sample
  },
  {
    title: "Background Jobs with Sidekiq",
    content: "Asynchronous processing is essential for modern apps. Complete Sidekiq tutorial for Rails applications...",
    published: true,
    user: created_users.sample
  },
  {
    title: "API Design: RESTful vs GraphQL",
    content: "Detailed comparison between different API design approaches, with practical examples...",
    published: true,
    user: created_users.sample
  },
  {
    title: "Caching Strategies in Rails",
    content: "From fragment caching to Redis, all caching strategies to speed up your Rails app...",
    published: false,
    user: created_users.sample
  }
]

created_posts = posts_data.map do |post_data|
  Post.create!(post_data)
end
puts "✅ Created #{created_posts.count} posts"

puts "🔗 Creating post-category associations..."
# Associate posts to categories realistically
associations = [
  { post_title: "Complete Guide to Active Record Queries", categories: ["Ruby on Rails", "Database", "Performance"] },
  { post_title: "Avoiding the N+1 Problem in Rails", categories: ["Ruby on Rails", "Performance", "Database"] },
  { post_title: "TDD with RSpec: From Basic to Advanced", categories: ["Testing", "Ruby on Rails"] },
  { post_title: "Deploying Rails Apps with Docker", categories: ["DevOps", "Ruby on Rails"] },
  { post_title: "Optimizing SQL Query Performance", categories: ["Performance", "Database"] },
  { post_title: "Hotwire: The Future of Rails Frontend", categories: ["Ruby on Rails", "JavaScript"] },
  { post_title: "Microservices with Rails: Pros and Cons", categories: ["Architecture", "Ruby on Rails"] },
  { post_title: "Background Jobs with Sidekiq", categories: ["Ruby on Rails", "Performance"] },
  { post_title: "API Design: RESTful vs GraphQL", categories: ["Architecture", "Ruby on Rails"] },
  { post_title: "Caching Strategies in Rails", categories: ["Performance", "Ruby on Rails"] }
]

associations.each do |assoc|
  post = created_posts.find { |p| p.title == assoc[:post_title] }
  assoc[:categories].each do |cat_name|
    category = created_categories.find { |c| c.name == cat_name }
    PostCategory.create!(post: post, category: category) if post && category
  end
end
puts "✅ Created post-category associations"

puts "💬 Creating comments..."
comment_contents = [
  "Excellent article! Very well explained with practical examples.",
  "Loved the tutorial, already implemented it in my app and it worked perfectly!",
  "Could you provide a more advanced example of this concept?",
  "Very useful, especially the performance section.",
  "Thanks for sharing! This saved my project.",
  "Interesting approach, I'll test it in my application.",
  "Could have covered edge cases, but overall very good.",
  "Complete and educational tutorial, congratulations!",
  "I have a question about the implementation...",
  "Perfect! I was looking for exactly this.",
  "Very well structured, easy to follow.",
  "Could you do a follow-up on this topic?",
  "Implemented following your steps and it worked on the first try!",
  "Great practices, I'll apply them with my team.",
  "Quality content, I always follow your posts."
]

# Create 2-5 comments for each published post
published_posts = created_posts.select(&:published)
total_comments = 0

published_posts.each do |post|
  num_comments = rand(2..5)

  num_comments.times do
    Comment.create!(
      content: comment_contents.sample,
      post: post,
      user: created_users.sample
    )
    total_comments += 1
  end
end

puts "✅ Created #{total_comments} comments"

puts "\n🎉 Seed completed successfully!"
puts "\n📊 Summary:"
puts "  👥 Users: #{User.count}"
puts "  📂 Categories: #{Category.count}"
puts "  📝 Posts: #{Post.count} (#{Post.where(published: true).count} published)"
puts "  🔗 Post-Category associations: #{PostCategory.count}"
puts "  💬 Comments: #{Comment.count}"

puts "\n🚀 Ready to start! Try these commands in console:"
puts "  User.first.posts"
puts "  Post.includes(:user, :categories, :comments).first"
puts "  Category.joins(:posts).group('categories.name').count"