module Korolev

  class DefaultConstructorError < StandardError
    def initialize(name)
      super "Custom constructor can't have name '#{name}', "
            "it is reserved for default constructor."
    end
  end

  class IncludeInModuleError < StandardError
    def initialize(base)
      super "Korolev can't be included in module '#{base.name}' directly, " +
            "use included hook or ActiveSupport::Concern."
    end
  end

end