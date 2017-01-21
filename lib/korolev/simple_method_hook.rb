module Korolev
  module SimpleMethodHook

    private

    def method_added(name)
      @konstructor ||= Konstructor.new(self)
      @konstructor.method_added_to_klass(name)
      super
    end

    def self.setup(base)
      class << base
        # Ruby itself checks against double include
        include Korolev::SimpleMethodHook
      end
    end

  end
end
