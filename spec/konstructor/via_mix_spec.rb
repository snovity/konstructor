require 'spec_helper'
require_relative 'shared'

describe "Korolev.konstructor mixed" do

  context "when one custom constructor" do
    let_korolev_klass do
      konstructor
      konstructor :alpha
      def_betta

      def_alpha
    end

    include_examples "one custom constructor"
  end

  context "when two custom constructors" do
    let_korolev_klass do
      konstructor :alpha
      def_alpha

      konstructor
      def_betta
    end

    include_examples "two custom constructors"
  end

  context "when two custom constructors" do
    let_korolev_klass do
      def_alpha

      konstructor :alpha
      konstructor
      def_betta
    end

    include_examples "two custom constructors"
  end

  context "when two custom constructors" do
    let_korolev_klass do
      def_alpha

      konstructor
      def_betta
      konstructor :alpha
    end

    include_examples "two custom constructors"
  end

end