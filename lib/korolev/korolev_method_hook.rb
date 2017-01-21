module Korolev
  module KorolevMethodHook

    # Experimental and currently not used method_added hook approach protecting against method_added
    # overrides that are not calling super (hopefully, there is no such code in the wild).
    #
    # Since method_added hook is idempotent, there would be no harm done even if
    # overridding method_added actually had super call and Korolev's hook would be
    # called twice as a result of this.
    def self.setup(base)
      method_added_method = base.method(:method_added)
      if method_added_method.source_location
        method_added_file_path = method_added_method.source_location.first
        return if method_added_file_path.include?('korolev_method_hook')
      end

      base.instance_exec do
        private

        alias korolev_super_method_added method_added

        def method_added(name)
          @konstructor ||= Konstructor.new(self)
          @konstructor.method_added_to_klass(name)
          korolev_super_method_added(name)
        end
      end
    end

  end
end