require 'spec_helper'
require_relative '../shared'

describe "Korolev.konstructor via next method" do

  context "when one custom constructor" do
    let_korolev_klass do
      konstructor
      def_alpha
      def_betta
    end

    include_examples "one custom constructor"
  end

  context "when two custom constructors" do
    let_korolev_klass do
      konstructor
      def_alpha

      konstructor
      def_betta
    end

    include_examples "two custom constructors"
  end

  context "when two custom constructors in when methods are marked private" do
    let_korolev_klass do
      konstructor
      private
      def_alpha

      konstructor
      def_betta
    end

    include_examples "two custom constructors"
  end


end