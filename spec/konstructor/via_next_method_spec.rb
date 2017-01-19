require 'spec_helper'
require_relative 'shared'

describe "Korolev.konstructor via next method" do

  context "when one custom constructor" do
    let_klass do
      konstructor
      def alpha(one, two)
        @one, @two = one, two
      end

      def betta(three)
        @three = three
      end
    end

    include_examples "one custom constructor"
  end

  context "when two custom constructors" do
    let_klass do
      konstructor
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

  context "when two custom constructors in when methods are marked private" do
    let_klass do
      konstructor
      private
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


end