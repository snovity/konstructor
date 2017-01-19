require 'spec_helper'
require_relative 'shared'

describe "Korolev.konstructor mixed" do

  context "when one custom constructor" do
    let_klass do
      konstructor
      konstructor :alpha
      def betta(three)
        @three = three
      end

      def alpha(one, two)
        @one, @two = one, two
      end
    end

    include_examples "one custom constructor"
  end

  context "when two custom constructors" do
    let_klass do
      konstructor :alpha
      def alpha(one, two)
        @one, @two = one, two
      end

      konstructor
      def betta(three)
        @three = three
      end
    end

    include_examples "two custom constructors"
  end

  context "when two custom constructors" do
    let_klass do
      def alpha(one, two)
        @one, @two = one, two
      end

      konstructor :alpha
      konstructor
      def betta(three)
        @three = three
      end
    end

    include_examples "two custom constructors"
  end

  context "when two custom constructors" do
    let_klass do
      def alpha(one, two)
        @one, @two = one, two
      end

      konstructor
      def betta(three)
        @three = three
      end
      konstructor :alpha
    end

    include_examples "two custom constructors"
  end

end