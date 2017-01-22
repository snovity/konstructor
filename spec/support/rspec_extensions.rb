module RspecExtensions

  def let_klass(options = {}, &block)
    klass_name = options[:name] || :klass
    let(klass_name) do
      inherit = options[:inherit] ? send(options[:inherit]) : Object
      modules_to_include = Array(options[:include]).map { |module_var_name| send(module_var_name) }

      Class.new(inherit) do
        attr_reader :zero, :one, :two, :three

        unless options[:skip_initialize]
          def initialize
            @zero = 0
          end
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

        modules_to_include.each do |mod|
          include mod
        end

        class_exec(&block) if block_given?
      end
    end
  end

  def let_korolev_klass(options = {}, &block)
    let_klass(options) do
      include Korolev

      class_exec(&block)
    end
  end

end