require 'spec_helper'
require_relative '../shared'

describe "konstructor included when another module that adds method_added" do

  context "without super via extend" do
    module KonstructorCompetingExtend
      attr_reader :test_methods

      def method_added(name)
        @test_methods ||= []
        @test_methods << :"#{name}man"
      end
    end

    context "before Konstructor" do
      let_klass do
        extend KonstructorCompetingExtend
        include Konstructor

        konstructor
        def_alpha
        def_betta
      end

      specify { expect_working_module }

      include_examples "one custom constructor"
    end

    context "after Konstructor" do
      let_klass do
        include Konstructor
        extend KonstructorCompetingExtend

        konstructor
        def_alpha
        def_betta
      end

      specify { expect_working_module }

      include_examples "one custom constructor"
    end
  end

  context "with super via include" do
    module KonstructorCompetingIncludeSuper
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

    context "before Konstructor via include" do
      let_klass do
        include KonstructorCompetingIncludeSuper
        include Konstructor

        konstructor
        def_alpha
        def_betta
      end

      specify { expect_working_module }

      include_examples "one custom constructor"
    end

    context "after Konstructor via include" do
      let_klass do
        include Konstructor
        include KonstructorCompetingIncludeSuper

        konstructor
        def_alpha
        def_betta
      end

      specify { expect_working_module }

      include_examples "one custom constructor"
    end
  end

  context "without super via include" do
    module KonstructorCompetingInclude
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

    context "before Konstructor via include" do
      let_klass do
        include KonstructorCompetingInclude
        include Konstructor

        konstructor
        def_alpha
        def_betta
      end

      specify { expect_working_module }

      # doesn't work without experimental hook setup
      #include_examples "one custom constructor"
      include_examples "no custom constructors"
    end

    context "after Konstructor via include" do
      let_klass do
        include Konstructor
        include KonstructorCompetingInclude

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