module Konstructor

  class ReservedNameError < StandardError
    def initialize(name)
      super "Custom constructor can't have name '#{name}', "
            "it is reserved for default constructor."
    end
  end

  class IncludeInModuleError < StandardError
    def initialize(base)
      super "Konstructor can't be included in module '#{base.name}' directly, " +
            "please, use ActiveSupport::Concern or standard included hook."
    end
  end

  class DeclaringInheritedError < StandardError
    def initialize(name)
      super "You are declaring an inherited method '#{name}' as konstructor, "
            "this is not allowed."
    end
  end

end