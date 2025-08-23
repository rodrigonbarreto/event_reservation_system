  module Importer
    class JsonImporter
      attr_reader :file_name, :file_path

      def initialize(file_name:)
        @file_name = file_name
        @file_path = Rails.root.join(file_name)
      end

      def import!
        unless File.exist?(@file_path)
          raise "File not found: #{@file_path}"
        end

        puts "📁 Reading JSON file: #{@file_name}"
        file_content = File.read(@file_path)
        JSON.parse(file_content)
      rescue JSON::ParserError => e
        raise "Invalid JSON format: #{e.message}"
      rescue StandardError => e
        raise "Error reading file: #{e.message}"
      end
    end
end