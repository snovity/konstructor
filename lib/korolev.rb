require 'korolev/version'

module Korolev

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
        # defining class method
        klass.define_singleton_method(name) do |*args|
          instance = allocate
          instance.send(name, *args)
          instance
        end

        # marking instance method as private
        klass.send(:private, name)
      end
    end
  end
end
