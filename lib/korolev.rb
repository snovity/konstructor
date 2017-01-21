require 'korolev/version'
require 'korolev/exceptions'
require 'korolev/simple_method_hook'
require 'korolev/konstructor'

module Korolev

  module KonstructorMethod
    private

    def konstructor(*new_names)
      Korolev::SimpleMethodHook.setup(self)

      @konstructor ||= Korolev::Konstructor.new(self)
      @konstructor.declare(new_names)
    end
  end

  # Overriden append_features prevents default behavior
  # of including all the constants, variables to the base class.
  # It adds only one method 'konstructor'.
  def self.append_features(base)
    unless base.is_a? Class
      raise IncludeInModuleError, base
    end

    base.extend(KonstructorMethod)
  end

end
