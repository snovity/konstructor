require 'korolev/version'
require 'korolev/exceptions'
require 'korolev/method_hook'
require 'korolev/konstructor'

module Korolev

  module KonstructorMethod
    private

    def konstructor(*new_konstructor_names)
      class << self
        include Korolev::MethodHook
      end

      # experimental stuff
      Korolev::MethodHook.ensure_not_overriden(self)

      @konstructor ||= Korolev::Konstructor.new(self)
      @konstructor.declare_konstructors(new_konstructor_names)
    end
  end

  # Overriden append_features prevents default behavior
  # of including all the constants, variables in the base class.
  # It adds only one method konstructor.
  def self.append_features(base)
    unless base.is_a? Class
      raise IncludeInModuleError, base
    end

    base.extend(KonstructorMethod)
  end

end
