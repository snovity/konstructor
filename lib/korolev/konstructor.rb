module Korolev
  class Konstructor

    DEFAULT_CONSTRUCTOR_NAMES = [:new, :initialize]

    def initialize(klass)
      @klass = klass
      @konstructor_names = []
      @next_method_is_konstructor = false
    end

    def declare_konstructors(new_names)
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
    def declared_as_konstructor?(name)
      return true if @konstructor_names.include?(name)

      current_klass = @klass
      # trying to find superclass with Konstructor class instance
      while current_klass.respond_to?(:superclass) && current_klass.superclass.respond_to?(:konstructor, true)
        current_klass = current_klass.superclass
        konstructor = current_klass.instance_variable_get(:@konstructor)
        if konstructor
          return konstructor.declared_as_konstructor?(name)
        end
      end

      false
    end

    def method_added_to_klass(name)
      name = name.to_sym

      if @next_method_is_konstructor
        @next_method_is_konstructor = false
        @konstructor_names << name
        define_konstructor(name)
      elsif declared_as_konstructor?(name)
        define_konstructor(name)
      end
    end

    private

    def process_new_names(new_names)
      new_names = new_names.map(&:to_sym)
      @konstructor_names.concat(new_names)

      new_names.each do |name|
        if has_own_method?(name)
          define_konstructor(name)
        else
          # not sure if konstructor ever will be defined,
          # but informing the user about the problem anyway
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
    def define_konstructor(name)
      validate_name(name)
      # not sure if this eval-less way is fully portable between interpreters
      # klass.define_singleton_method(name) do |*args, &block|
      #   instance = allocate
      #   instance.send(name, *args, &block)
      #   instance
      # end

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
      if DEFAULT_CONSTRUCTOR_NAMES.include?(name)
        raise DefaultConstructorError, name
      end
    end
  end
end