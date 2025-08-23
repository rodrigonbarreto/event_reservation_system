module Importer
  class BadImporter
    def self.import!
      start_time = Time.current

      blog_json = Importer::JsonImporter.new(file_name: "blog_json_data_10k.json").import!

      # Process each post individually
      blog_json.each do |post_data|

        # Create user for every post (checks for duplicates every time!)
        user = User.find_or_create_by(email: post_data["user"]["email"]) do |u|
          u.name = post_data["user"]["name"]
          u.bio = post_data["user"]["bio"]
        end

        # Create post
        post = Post.find_or_create_by(title: post_data["title"]) do |p|
          p.content = post_data["content"]
          p.published = post_data["published"]
          p.user = user
        end

        # Create categories for every post (more checks!)
        post_data["categories"].each do |category_name|
          category = Category.find_or_create_by(name: category_name)

          # Create association
          PostCategory.find_or_create_by(post: post, category: category)
        end
      end

      elapsed_time = Time.current - start_time
      puts "Total time: #{elapsed_time.round(2)} seconds"
    end
  end
end