# frozen_string_literal: true
# rubocop:disable all
module Helpers
  module ContractToParams
    extend Grape::API::Helpers

    def self.generate_params(contract_class, options = {})
      annotations = extract_annotations(contract_class)
      contract = contract_class.new
      param_type = options[:param_type] || "body"

      contract.schema.rules.each_with_object({}) do |(name, rule), params_hash|
        type = extract_type(rule)
        required = !optional_field?(rule)
        description = annotations[name] || name.to_s.humanize

        params_hash[name] = {
          type: type,
          desc: description,
          required: required,
          documentation: { param_type: param_type }
        }
      end
    end

    def self.extract_annotations(contract_class)
      # Lê o conteúdo do arquivo fonte usando o path da classe
      file_path = contract_class.name.underscore
      paths_to_try = [
        Rails.root.join("app/contracts/", "#{file_path}.rb"),
        Rails.root.join("app/api/contracts/", "#{file_path}.rb"),
        Rails.root.join("app/models/#{file_path}.rb")
      ]

      source_path = paths_to_try.find { |path| File.exist?(path) }
      return {} unless source_path

      source_lines = File.readlines(source_path)
      annotations = {}
      field_pattern = /\s*(optional|required)\(:([\w_]+)\)/

      source_lines.each_with_index do |line, index|
        next unless line.match?(field_pattern)

        field_name = line.match(field_pattern)[2]

        previous_line = source_lines[index - 1]
        if previous_line&.match?(/^\s*#\s*@#{field_name}\s*=\s*(.+)/)
          annotations[field_name.to_sym] = previous_line.match(/^\s*#\s*@#{field_name}\s*=\s*(.+)/)[1].strip
        end
      end

      annotations
    end

    def self.extract_type(rule)
      predicates = extract_all_predicates(rule)

      return [TrueClass, FalseClass] if predicates.include?(:bool?)
      return Integer if predicates.include?(:int?) || predicates.include?(:integer?)
      return Float if predicates.include?(:float?)
      return Array if predicates.include?(:array?)
      return Hash if predicates.include?(:hash?)
      return Date if predicates.include?(:date?)
      return Time if predicates.include?(:time?)

      String
    end

    def self.extract_all_predicates(rule)
      predicates = []

      case rule
      when Dry::Logic::Operations::And, Dry::Logic::Operations::Or
        rule.rules.each do |sub_rule|
          predicates.concat(extract_all_predicates(sub_rule))
        end
      when Dry::Logic::Operations::Key
        predicates.concat(extract_all_predicates(rule.rules.first))
      when Dry::Logic::Operations::Implication
        predicates << :optional
        rule.rules.each do |sub_rule|
          predicates.concat(extract_all_predicates(sub_rule))
        end
      when Dry::Logic::Rule::Predicate
        predicates << rule.predicate.name if rule.predicate&.name
      end

      predicates.uniq
    end

    def self.optional_field?(rule)
      return true if rule.is_a?(Dry::Logic::Operations::Implication)

      if rule.is_a?(Dry::Logic::Operations::And)
        rule.rules.any? do |sub_rule|
          sub_rule.is_a?(Dry::Logic::Operations::Implication)
        end
      else
        false
      end
    end
  end
end
# rubocop:enable all