require 'spec_helper'
require_relative '../shared'
require 'konstructor'

describe "thread safety for konstructor next method" do

  context "when concurrent definiton defines regular method first" do
    let_klass do
      klass = self

      konstructor
      concurrent_definition = Thread.new do
        klass.class_exec do
          def gamma
          end

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

  context "when concurrent definition defines another constructor first" do
    let_klass do
      klass = self

      konstructor
      concurrent_definition = Thread.new do
        klass.class_exec do
          konstructor
          def_betta

          def gamma
          end
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