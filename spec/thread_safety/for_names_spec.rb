require 'spec_helper'
require_relative '../shared'
require 'konstructor'

describe "thread safety for konstructor names" do

  context "when concurrent definition declares & defines another constructor" do
    let_klass do
      klass = self

      konstructor :alpha
      concurrent_definition = Thread.new do
        klass.class_exec do
          def gamma
          end

          konstructor :betta
          def_betta
        end
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
    let_klass do
      klass = self

      konstructor :alpha
      concurrent_definition = Thread.new do
        klass.class_exec do
          def gamma
          end

          konstructor :alpha, :betta
          def_betta
        end
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
    let_klass do
      klass = self

      concurrent_definition = Thread.new do
        klass.class_exec do
          def gamma
          end

          konstructor :alpha, :betta
          def_betta
        end
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