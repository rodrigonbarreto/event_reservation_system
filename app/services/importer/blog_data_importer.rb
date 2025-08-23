module Importer
  class BlogDataImporter
    def self.import!
      start_time = Time.current

      ActiveRecord::Base.transaction do
        blog_json = Importer::JsonImporter.new(file_name: "blog_json_data_10k.json").import!

        # Extract unique data BEFORE inserting
        categories = blog_json.map{ |post| post["categories"] }.flatten.uniq
        users = blog_json.map{ |post| post["user"] }.uniq { |user| user["email"] }

        # Insert categories and users all at once
        Category.insert_all(categories.map { |category| {name: category} })
        User.insert_all(users.map { |user| {name: user["name"], email: user["email"], bio: user["bio"]} })

        # Create lookup hashes (KEY OPTIMIZATION!)
        categories_hash = Category.all.pluck(:name, :id).to_h
        users_hash = User.all.pluck(:email, :id).to_h

        # Import posts
        blog_json.map do |post|
          result = {
            title: post["title"],
            content: post["content"],
            published: post["published"],
            user_id: users_hash[post["user"]["email"]]
          }
          post_data = Post.create!(result)

          # Create post-category associations in batch
          PostCategory.insert_all(
            post["categories"].map { |category|
              {post_id: post_data.id, category_id: categories_hash[category]}
            }
          )
        end

      rescue ActiveRecord::RecordInvalid, StandardError => e
        error = "Error: #{e.message}"
        puts error
        Rails.logger.error error
      end

      elapsed_time = Time.current - start_time
      puts "Total time: #{elapsed_time.round(2)} seconds"
    end
  end
end