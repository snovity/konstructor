require 'korolev/version'

module Korolev

  class DefaultConstructorError < StandardError
    def initialize(name)
      super "Custom constructor can't have name '#{name}', it is reserved for default constructor."
    end
  end

  # it is a cross-cutting concern, therefore using a module instead of base class
  # it should be a module
  def self.included(base)
    base.instance_exec do
      # is multiple include possible?
      @konstructor_names ||= []

      private

      def konstructor(*konstructor_names)
        if konstructor_names.empty?
          @next_method_is_konstructor = true
        else
          @next_method_is_konstructor = nil
          @konstructor_names.concat(konstructor_names.map(&:to_sym))
          @konstructor_names.each do |name|
            if method_defined?(name) || private_method_defined?(name)
              setup_konstructor(self, name)
            else
              # not sure if konstructor ever will be defined,
              # but want to inform the user about the problem anyway
              validate_name(name)
            end
          end
        end
      end

      def method_added(name)
        name = name.to_sym

        if @next_method_is_konstructor
          @konstructor_names << name
          @next_method_is_konstructor = nil
          setup_konstructor(self, name)
        elsif @konstructor_names.include?(name)
          setup_konstructor(self, name)
        end
      end

      def setup_konstructor(klass, name)
        validate_name(name)
        # not sure if this eval-less way is fully portable
        # klass.define_singleton_method(name) do |*args, &block|
        #   instance = allocate
        #   instance.send(name, *args, &block)
        #   instance
        # end

        # defining class method
        klass.instance_eval <<-RUBY, __FILE__, __LINE__
          def #{name}(*args, &block)
            instance = allocate
            instance.send(:#{name}, *args, &block)
            instance
          end
        RUBY

        # marking instance method as private
        klass.send(:private, name)
      end

      def validate_name(name)
        if [:new, :initialize].include?(name)
          raise DefaultConstructorError, name
        end
      end
    end
  end
end
