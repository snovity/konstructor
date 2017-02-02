require 'spec_helper'
require_relative '../shared'

describe "thread safety for konstructor mixed usage" do

  context "when concurrent definition defines & declares another konstructor via name" do
    let_konstructor_klass do
      konstructor
      concurrent_definition = Thread.new do
        def gamma
        end

        def_betta

        konstructor :betta
      end
      concurrent_definition.join

      def_alpha
    end

    include_examples "two custom constructors"

    specify "gamma is not a constructor" do
      expect { klass.gamma }.to raise_error(NoMethodError)
    end
  end

  context "when concurrent definition declares one constructor and declares & defines another one" do
    let_konstructor_klass do
      concurrent_definition = Thread.new do
        def gamma
        end

        konstructor :alpha

        konstructor
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

  context "when concurrent definition redeclares already declared & defined constructor" do
    let_konstructor_klass do
      konstructor
      def_alpha

      concurrent_definition = Thread.new do
        def gamma
        end

        konstructor :alpha

        konstructor
        def_betta
      end
      concurrent_definition.join
    end

    include_examples "two custom constructors"

    specify "gamma is not a constructor" do
      expect { klass.gamma }.to raise_error(NoMethodError)
    end
  end

end