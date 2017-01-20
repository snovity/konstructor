require 'spec_helper'
require_relative 'shared'

# WHAT ABOUT WHEN DECLARATION USED IN MODULE AND IT IS INCLUDED,
# maybe just raise an error?
describe "Korolev.konstructor via names" do

  context "when no custom constructors" do
    let_klass do
      def_alpha

      def_betta
    end

    include_examples "no custom constructors"
  end

  context "when one custom constructor" do
    let_klass do
      konstructor :alpha
      def_alpha

      def_betta
    end

    include_examples "one custom constructor"
  end

  context "when two constructor declarations for the same method before it" do
    let_klass do
      konstructor :alpha
      konstructor :alpha
      def_alpha

      def_betta
    end

    include_examples "one custom constructor"
  end

  context "when two constructor declarations for the same method before and after it" do
    let_klass do
      konstructor :alpha
      def_alpha
      konstructor :alpha

      def_betta
    end

    include_examples "one custom constructor"
  end

  context "when two custom constructors before method definitions" do
    let_klass do
      konstructor :alpha, :betta

      def_alpha

      def_betta
    end

    include_examples "two custom constructors"
  end

  context "when two custom constructors in the middle of method definitions" do
    let_klass do
      def_alpha

      konstructor :alpha, :betta

      def_betta
    end

    include_examples "two custom constructors"
  end

  context "when two custom constructors after method definitions" do
    let_klass do
      def_alpha

      def_betta

      konstructor :alpha, :betta
    end

    include_examples "two custom constructors"
  end

  context "when two custom constructors in two different calls" do
    let_klass do
      konstructor :alpha
      konstructor :betta

      def_alpha

      def_betta
    end

    include_examples "two custom constructors"
  end

  context "when methods are private" do
    let_klass do
      private

      def_alpha

      def_betta

      konstructor :alpha, :betta
    end

    include_examples "two custom constructors"
  end

end
