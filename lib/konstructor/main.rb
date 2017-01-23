require 'konstructor/version'
require 'konstructor/exceptions'
require 'konstructor/simple_method_hook'
require 'konstructor/factory'

module Konstructor

  module KonstructorMethod
    private

    # TODO: ADD DOCS
    def konstructor(*new_names)
      Konstructor.declare(self, new_names)
    end
  end

  DEFAULT_NAMES = [:initialize]
  RESERVED_NAMES = [:new, :initialize]

  class << self
    def reserved?(name)
      RESERVED_NAMES.include?(name.to_sym)
    end

    def default?(name)
      DEFAULT_NAMES.include?(name.to_sym)
    end

    def declared?(klass, name)
      konstructor = get_factory(klass)
      if konstructor
        konstructor.declared?(name.to_sym)
      else
        false
      end
    end

    def declare(klass, new_names)
      setup_method_added_hook(klass)
      get_or_init_factory(klass).declare(new_names)
    end

    def method_added_to_klass(klass, name)
      get_or_init_factory(klass).method_added_to_klass(name)
    end

    def is?(klass, name)
      default?(name) || declared?(klass, name)
    end

    private

    def get_factory(klass)
      klass.instance_variable_get(:@konstructor)
    end

    def init_factory(klass)
      # using variable @konstructor to minimize footprint, although saving factory there
      klass.instance_variable_set(:@konstructor, Factory.new(klass))
    end

    def get_or_init_factory(klass)
      get_factory(klass) || init_factory(klass)
    end

    def setup_method_added_hook(klass)
      SimpleMethodHook.setup(klass)
    end

    # Overriden append_features prevents default behavior
    # of including all the constants, variables to the base class.
    # It adds only one method 'konstructor'.
    def append_features(klass)
      unless klass.is_a? Class
        raise IncludeInModuleError, klass
      end

      klass.extend(KonstructorMethod)
    end
  end

end