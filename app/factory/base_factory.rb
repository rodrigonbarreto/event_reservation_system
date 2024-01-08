class BaseFactory
  class << self
    def call(...)
      new(...).call
    end
  end

  def call
    raise NotImplementedError, "'#{__method__}' should be implemented in concrete class"
  end
end
