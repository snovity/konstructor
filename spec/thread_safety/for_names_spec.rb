require 'spec_helper'
require_relative '../shared'

describe "thread safety for konstructor names" do

  context "when concurrent definition declares & defines another constructor" do
    let_konstructor_klass do
      konstructor :alpha
      concurrent_definition = Thread.new do
        def gamma
        end

        konstructor :betta
        def_betta
      end
      concurrent_definition.join

      def_alpha
    end

    include_examples "two custom constructors"

    specify "gamma is not a constructor" do
      expect { klass.gamma }.to raise_error(NoMethodError)
    end
  end

  context "when concurrent definition redeclares not yet defined constructor" do
    let_konstructor_klass do
      konstructor :alpha
      concurrent_definition = Thread.new do
        def gamma
        end

        konstructor :alpha, :betta
        def_betta
      end
      concurrent_definition.join

      def_alpha
    end

    include_examples "two custom constructors"

    specify "gamma is not a constructor" do
      expect { klass.gamma }.to raise_error(NoMethodError)
    end
  end

  context "when concurrent definition declares not yet defined constructor" do
    let_konstructor_klass do
      concurrent_definition = Thread.new do
        def gamma
        end

        konstructor :alpha, :betta
        def_betta
      end
      concurrent_definition.join

      def_alpha
    end

    include_examples "two custom constructors"

    specify "gamma is not a constructor" do
      expect { klass.gamma }.to raise_error(NoMethodError)
    end
  end

end