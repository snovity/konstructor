require 'korolev/version'

module Korolev

  # it is a cross-cutting concern, therefor using a base class is incorrect, it should be a module
  def self.included(base)
    base.instance_exec do
      # is multiple include possible?
      @constructor_names ||= []

      private

      def konstructor(*constructor_names)
        if constructor_names.empty?
          @next_method_is_constructor = true
        else
          @constructor_names += constructor_names.map(&:to_sym)
        end

        # self.class_exec do
        #   binding.pry
        # end
      end

      def method_added(name)
        if @next_method_is_constructor || @constructor_names.include?(name.to_sym)
          # defining class method
          self.define_singleton_method(name) do |*args|
            instance = allocate
            instance.send(name, *args)
            instance
          end

          # marking instance method as private
          private name

          @next_method_is_constructor = false
        end
      end
    end
  end
end
