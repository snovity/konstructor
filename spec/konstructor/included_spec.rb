require 'spec_helper'
require_relative 'shared'

describe "Korolev.konstructor included" do

  context "without ActiveSupport::Concern" do
    let(:some_module) do
      Module.new do
        def self.name
          'SomeModule'
        end

        include Korolev
      end
    end

    subject { some_module }

    specify { expect_to_raise Korolev::IncludeInModuleError }
  end

  context "with ActiveSupport::Concern" do
    require 'active_support/concern'

    context "via names" do
      let(:some_module) do
        Module.new do
          extend ActiveSupport::Concern

          included do
            include Korolev

            konstructor :betta
          end

          attr_reader :zero, :one, :two, :three

          def betta(three)
            @three = three
          end

          def initialize
            @zero = 0
          end
        end
      end

      let_klass(include: :some_module) do
        konstructor
        def alpha(one, two)
          @one, @two = one, two
        end
      end

      include_examples "two custom constructors"
    end

    context "via next method" do
      let(:some_module) do
        Module.new do
          extend ActiveSupport::Concern

          included do
            include Korolev

            konstructor
            def betta(three)
              @three = three
            end
          end

          attr_reader :zero, :one, :two, :three

          def initialize
            @zero = 0
          end
        end
      end

      let_klass(include: :some_module) do
        konstructor
        def alpha(one, two)
          @one, @two = one, two
        end
      end

      include_examples "two custom constructors"
    end
  end

  context "when another module that adds method_added" do
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

    context "via include" do
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

  context "when current class uses method added" do

  end

  context "when base class uses method_added" do
    let_klass(name: :base_klass) do

    end
  end

end