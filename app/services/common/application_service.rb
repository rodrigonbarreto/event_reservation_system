# frozen_string_literal: true

class Common::ApplicationService
  # def self.call(*arg)
  class << self
    def call(*arg)
      new(*arg).constructor
    end
  end

  attr_reader :result

  def constructor
    @result = call
    self
  end

  def success?
    !failure?
  end

  def failure?
    errors.any?
  end

  def errors
    @errors ||= Errors.new
  end

  def call
    raise NotImplementedError unless defined?(super)
  end
end
