require 'spec_helper'
require_relative '../shared'
require 'konstructor'

describe "thread safety for konstructor mixed usage" do

  context "when concurrent definition defines & declares another konstructor via name" do
    let_klass do
      klass = self

      konstructor
      concurrent_definition = Thread.new do
        klass.class_exec do
          def gamma
          end

          def_betta

          konstructor :betta
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

  context "when concurrent definition declares one constructor and declares & defines another one" do
    let_klass do
      klass = self

      concurrent_definition = Thread.new do
        klass.class_exec do
          def gamma
          end

          konstructor :alpha

          konstructor
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

  context "when concurrent definition redeclares already declared & defined constructor" do
    let_klass do
      klass = self

      konstructor
      def_alpha

      concurrent_definition = Thread.new do
        klass.class_exec do
          def gamma
          end

          konstructor :alpha

          konstructor
          def_betta
        end
      end
      concurrent_definition.join
    end

    include_examples "two custom constructors"

    specify "gamma is not a constructor" do
      expect { klass.gamma }.to raise_error(NoMethodError)
    end
  end

end