module Importer
  class BlogDataImporterWithActiveRecordImport
    def self.import!
      start_time = Time.current

      ActiveRecord::Base.transaction do
        blog_json = Importer::JsonImporter.new(file_name: "blog_json_data_10k.json").import!

        # Prepare unique data
        categories = blog_json.map{ |post| post["categories"] }.flatten.uniq
        users = blog_json.map{ |post| post["user"] }.uniq { |user| user["email"] }

        # Import categories and users in batch
        category_objects = categories.map { |name| Category.new(name: name) }
        Category.import category_objects, on_duplicate_key_ignore: true, validate: false

        user_objects = users.map { |user|
          User.new(name: user["name"], email: user["email"], bio: user["bio"])
        }
        User.import user_objects, on_duplicate_key_ignore: true, validate: false

        # Create lookup hashes
        categories_hash = Category.all.pluck(:name, :id).to_h
        users_hash = User.all.pluck(:email, :id).to_h

        # Import posts in batches to save memory
        blog_json.in_groups_of(1000, false) do |post_batch|
          posts_to_import = post_batch.map do |post|
            Post.new(
              title: post["title"],
              content: post["content"],
              published: post["published"],
              user_id: users_hash[post["user"]["email"]]
            )
          end

          # Import this batch of posts (without validations for maximum performance!)
          Post.import posts_to_import, validate: false
        end

        # Prepare and import associations in batches
        Post.where(title: blog_json.map { |p| p["title"] }).find_in_batches(batch_size: 1000) do |post_batch|
          post_categories = []

          post_batch.each do |post|
            post_data = blog_json.find { |p| p["title"] == post.title }
            post_data["categories"].each do |category_name|
              post_categories << PostCategory.new(
                post_id: post.id,
                category_id: categories_hash[category_name]
              )
            end
          end

          # Import associations for this batch (without validations!)
          PostCategory.import post_categories, validate: false if post_categories.any?
        end

      rescue StandardError => e
        error = "Error: #{e.message}"
        puts error
        Rails.logger.error error
      end

      elapsed_time = Time.current - start_time
      puts "Total time: #{elapsed_time.round(2)} seconds"
    end
  end
end