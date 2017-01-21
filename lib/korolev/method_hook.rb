module Korolev
  module MethodHook

    private

    def method_added(name)
      @konstructor ||= Konstructor.new(self)
      @konstructor.method_added_to_klass(name)
      super
    end

    # This method protects against method_added overrides that are not calling super.
    # Since method_added hook is idempotent, there would be no harm done even if
    # override actually has super and hook is called twice.
    def self.ensure_not_overriden(base)
      return if base.method(:method_added).source_location.first.include?('korolev/method_hook')

      base.instance_exec do
        private

        alias orig_method_added method_added

        def method_added(name)
          @konstructor ||= Konstructor.new(self)
          @konstructor.method_added_to_klass(name)
          orig_method_added(name)
        end
      end
    end
  end
end
