require 'spec_helper'
require_relative '../shared'

describe "konstructor included when another module that adds method_added" do

  context "when base class uses method_added" do
    let_klass(name: :base_klass) do
      class << self
        attr_reader :test_methods

        def method_added(name)
          @test_methods ||= []
          @test_methods << :"#{name}man"
        end
      end
    end

    let_konstructor_klass(inherit: :base_klass) do
      konstructor
      def_alpha
      def_betta
    end

    include_examples "one custom constructor"
  end

  context "when current class uses method added with super" do
    let_konstructor_klass do
      class << self
        attr_reader :test_methods

        def method_added(name)
          @test_methods ||= []
          @test_methods << :"#{name}man"
          super
        end
      end

      konstructor
      def_alpha
      def_betta
    end

    specify { expect_working_module }

    include_examples "one custom constructor"
  end

  context "when current class uses method added without super" do
    let_konstructor_klass do
      class << self
        attr_reader :test_methods

        def method_added(name)
          @test_methods ||= []
          @test_methods << :"#{name}man"
        end
      end

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