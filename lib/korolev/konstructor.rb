module Korolev
  class Konstructor

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
        konstructor = klass.instance_variable_get(:@konstructor)
        if konstructor
          konstructor.declared?(name.to_sym)
        else
          false
        end
      end

      def is?(klass, name)
        default?(name) || declared?(klass, name)
      end
    end

    def initialize(klass)
      @klass = klass
      @konstructor_names = []
      @next_method_is_konstructor = false
    end

    def declare(new_names)
      if new_names.empty?
        @next_method_is_konstructor = true
      else
        @next_method_is_konstructor = false
        process_new_names(new_names)
      end
    end

    # once method is a konstructor, it is always a konstructor, this differs
    # from the way private, protected works, if overriding method isn't repeatedly marked as private
    # it becomes public
    def declared?(name)
      declared_in_self?(name) || declared_in_superclass?(name)
    end

    def method_added_to_klass(name)
      name = name.to_sym

      if @next_method_is_konstructor
        @next_method_is_konstructor = false
        @konstructor_names << name
        define(name)
      elsif declared?(name)
        define(name)
      end
    end

    private

    def declared_in_self?(name)
      @konstructor_names.include?(name.to_sym)
    end

    def declared_in_superclass?(name)
      current_klass = @klass

      # looking for superclass with Konstructor class instance
      while current_klass.respond_to?(:superclass) && current_klass.superclass.respond_to?(:konstructor, true)
        current_klass = current_klass.superclass
        return true if Konstructor.declared?(current_klass, name)
      end

      false
    end

    def process_new_names(new_names)
      new_names = new_names.map(&:to_sym)
      @konstructor_names.concat(new_names)

      new_names.each do |name|
        if has_own_method?(name)
          define(name)
        else
          # not sure if konstructor ever will be defined,
          # but informing about the problem anyway
          validate_name(name)
        end
      end
    end

    def has_own_method?(name)
      method_defined = @klass.method_defined?(name) || @klass.private_method_defined?(name)
      superclass_method_defined = @klass.respond_to?(:superclass) && (
        @klass.superclass.method_defined?(name) || @klass.superclass.private_method_defined?(name)
      )
      method_defined && !superclass_method_defined
    end

    # this method is idempotent
    def define(name)
      validate_name(name)
      
      # defining class method
      @klass.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{name}(*args, &block)
          instance = allocate
          instance.__send__(:#{name}, *args, &block)
          instance
        end
      RUBY

      # marking instance method as private
      @klass.__send__(:private, name)
    end

    def validate_name(name)
      if Konstructor.reserved?(name)
        raise ReservedNameError, name
      end
    end
  end
end