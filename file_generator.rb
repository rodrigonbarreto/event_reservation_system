# file_generator.rb (na raiz do projeto)
require 'json'
require 'faker'

base_users = [
  { name: "John Smith", email: "john@example.com", bio: "Ruby on Rails dev..." },
  { name: "Sarah Johnson", email: "sarah@example.com", bio: "Tech Lead..." },
  { name: "Mike Wilson", email: "mike@example.com", bio: "Full-stack dev..." },
  { name: "Emma Davis", email: "emma@example.com", bio: "DevOps engineer..." },
  { name: "Alex Rodriguez", email: "alex@example.com", bio: "Senior dev..." }
]

base_titles = [
  "Complete Guide to Active Record Queries",
  "Avoiding the N+1 Problem in Rails",
  "TDD with RSpec: From Basic to Advanced"
]

base_contents = [
  "In this article, we explore...",
  "Let's dive deep into...",
  "This tutorial covers..."
]

base_categories = ["Ruby on Rails", "Performance", "Database", "DevOps", "Architecture"]

posts = []

10_000.times do |i|
  user = base_users.sample
  post = {
    title: "#{base_titles.sample} ##{i}",
    content: "#{base_contents.sample} #{Faker::Lorem.paragraph(sentence_count: 5)}",
    published: [true, false].sample,
    user: user,
    categories: base_categories.sample(rand(1..3))
  }
  posts << post
end

File.write("blog_json_data_10k.json", JSON.pretty_generate(posts))