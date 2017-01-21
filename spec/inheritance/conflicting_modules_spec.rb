require 'spec_helper'
require_relative '../shared'

describe "Korolev.konstructor included when another module that adds method_added" do

  context "without super via extend" do
    module KorolevCompetingExtend
      attr_reader :test_methods

      def method_added(name)
        @test_methods ||= []
        @test_methods << :"#{name}man"
      end
    end

    context "before Korolev" do
      let_klass do
        extend KorolevCompetingExtend
        include Korolev

        konstructor
        def_alpha
        def_betta
      end

      specify { expect_working_module }

      include_examples "one custom constructor"
    end

    context "after Korolev" do
      let_klass do
        include Korolev
        extend KorolevCompetingExtend

        konstructor
        def_alpha
        def_betta
      end

      specify { expect_working_module }

      include_examples "one custom constructor"
    end
  end

  context "with super via include" do
    module KorolevCompetingIncludeSuper
      def self.included(base)
        class << base
          attr_reader :test_methods

          def method_added(name)
            @test_methods ||= []
            @test_methods << :"#{name}man"
            super
          end
        end
      end
    end

    context "before Korolev via include" do
      let_klass do
        include KorolevCompetingIncludeSuper
        include Korolev

        konstructor
        def_alpha
        def_betta
      end

      specify { expect_working_module }

      include_examples "one custom constructor"
    end

    context "after Korolev via include" do
      let_klass do
        include Korolev
        include KorolevCompetingIncludeSuper

        konstructor
        def_alpha
        def_betta
      end

      specify { expect_working_module }

      include_examples "one custom constructor"
    end
  end

  context "without super via include" do
    module KorolevCompetingInclude
      def self.included(base)
        class << base
          attr_reader :test_methods

          def method_added(name)
            @test_methods ||= []
            @test_methods << :"#{name}man"
          end
        end
      end
    end

    context "before Korolev via include" do
      let_klass do
        include KorolevCompetingInclude
        include Korolev

        konstructor
        def_alpha
        def_betta
      end

      specify { expect_working_module }

      # doesn't work without experimental hook setup
      #include_examples "one custom constructor"
      include_examples "no custom constructors"
    end

    context "after Korolev via include" do
      let_klass do
        include Korolev
        include KorolevCompetingInclude

        konstructor
        def_alpha
        def_betta
      end

      specify { expect_working_module }

      # doesn't work without experimental hook setup
      #include_examples "one custom constructor"
      include_examples "no custom constructors"
    end
  end

end