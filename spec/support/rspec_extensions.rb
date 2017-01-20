module RspecExtensions

  def let_klass(options = {}, &block)
    let(options[:name] || :klass) do
      inherit = options[:inherit] ? send(options[:inherit]) : Object

      Class.new(inherit, &block)
    end
  end

  def let_korolev_klass(options = {}, &block)
    let_klass(options) do
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

      class_exec(&block)
    end
  end

end