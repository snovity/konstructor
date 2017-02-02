require 'spec_helper'
require_relative '../shared'

describe "konstructor keyword is missing without Konstructor module" do

  context "without include" do
    let_klass do
      konstructor
      def_alpha
    end

    subject { klass }

    specify { expect_to_raise NameError }
  end

  context "with include" do
    let_klass do
      include Konstructor

      konstructor
      def_alpha

      def_betta
    end

    include_examples "one custom constructor"
  end

end