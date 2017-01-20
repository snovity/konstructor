module RspecExtensions

  def let_klass(options = {}, &block)
    klass = Class.new(options[:inherit] || Object) do
      include Korolev

      attr_reader :zero, :one, :two, :three

      def initialize
        @zero = 0
      end

      def self.def_alpha
        def alpha(one, two)
          @one, @two = one, two
        end
      end

      def self.def_betta
        def betta(three)
          @three = three
        end
      end
    end
    klass.class_exec(&block)

    let(:klass) { klass }
  end

end