require 'spec_helper'
require_relative 'shared'

describe "Korolev.konstructor included when another module that adds method_added" do

  def expect_working_module
    expect(klass.test_methods).to eq [:zero, :one, :two, :three, :initialize, :alpha, :betta]
  end

  context "via extend" do
    module KorolevCompetingExtend
      attr_reader :test_methods

      def method_added(name)
        @test_methods ||= []
        @test_methods << name
      end
    end

    context "before Korolev" do
      let_klass do
        extend KorolevCompetingExtend
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
        extend KorolevCompetingExtend

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

  context "via include" do
    module KorolevCompetingInclude
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
        include KorolevCompetingInclude
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

      # doesn't work without experimental hook setup
      #include_examples "one custom constructor"
    end

    context "after Korolev via include" do
      let_klass do
        include Korolev
        include KorolevCompetingInclude

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

      # doesn't work without experimental hook setup
      #include_examples "one custom constructor"
    end
  end

end