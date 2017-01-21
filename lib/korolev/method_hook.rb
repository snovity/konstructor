module Korolev
  module MethodHook

    private

    def method_added(name)
      @konstructor ||= Konstructor.new(self)
      @konstructor.method_added_to_klass(name)
      super
    end

    # Experimental method protecting against method_added overrides that
    # are not calling super.
    # Since method_added hook is idempotent, there would be no harm done even if
    # override actually had super call and Korolev's hook would be called twice.
    def self.ensure_not_overriden(base)
      def_file_path = base.method(:method_added).source_location.first
      if def_file_path.include?('korolev/method_hook') || def_file_path.include?('korolev\method_hook')
        return
      end

      base.instance_exec do
        private

        alias orig_method_added method_added

        def method_added(name)
          @konstructor ||= Konstructor.new(self)
          @konstructor.method_added_to_klass(name)
          orig_method_added(name)
        end
      end
      true
    rescue
      false
    end
  end
end
