require 'spec_helper'
require_relative 'shared'

describe "Korolev.konstructor included when another module that adds method_added" do

  def expect_working_module
    expect(klass.test_methods).to eq [:zero, :one, :two, :three, :initialize, :alpha, :betta]
  end

  context "via extend" do
    module KorolevTestModuleOne
      attr_reader :test_methods

      def method_added(name)
        @test_methods ||= []
        @test_methods << name
      end
    end

    context "before Korolev" do
      let_klass do
        extend KorolevTestModuleOne
        include Korolev

        attr_reader :zero, :one, :two, :three

        def initialize
          @zero = 0
        end

        konstructor
        def alpha(one, two)
          @one, @two = one, two
        end

        def betta(three)
          @three = three
        end
      end

      specify { expect_working_module }

      include_examples "one custom constructor"
    end

    context "after Korolev" do
      let_klass do
        include Korolev
        extend KorolevTestModuleOne

        attr_reader :zero, :one, :two, :three

        def initialize
          @zero = 0
        end

        konstructor
        def alpha(one, two)
          @one, @two = one, two
        end

        def betta(three)
          @three = three
        end
      end

      specify { expect_working_module }

      include_examples "one custom constructor"
    end
  end

  xcontext "via include" do
    module KorolevTestModuleTwo
      def self.included(base)
        class << base
          attr_reader :test_methods

          def method_added(name)
            @test_methods ||= []
            @test_methods << name
          end
        end
      end
    end

    context "before Korolev via include" do
      let_klass do
        include KorolevTestModuleTwo
        include Korolev

        attr_reader :zero, :one, :two, :three

        def initialize
          @zero = 0
        end

        konstructor
        def alpha(one, two)
          @one, @two = one, two
        end

        def betta(three)
          @three = three
        end
      end

      specify { expect_working_module }

      include_examples "one custom constructor"
    end

    context "after Korolev via include" do
      let_klass do
        include Korolev
        include KorolevTestModuleTwo

        attr_reader :zero, :one, :two, :three

        def initialize
          @zero = 0
        end

        konstructor
        def alpha(one, two)
          @one, @two = one, two
        end

        def betta(three)
          @three = three
        end
      end

      specify { expect_working_module }

      include_examples "one custom constructor"
    end
  end

end