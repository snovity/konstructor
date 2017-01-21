require 'spec_helper'
require_relative 'shared'

describe "Korolev.konstructor included when another module that adds method_added" do

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

    let_korolev_klass(inherit: :base_klass) do
      konstructor
      def_alpha
      def_betta
    end

    include_examples "one custom constructor"
  end

  context "when current class uses method added" do
    let_korolev_klass do
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