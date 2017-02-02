require 'spec_helper'
require_relative '../shared'

describe "konstructor without include" do

  before :all do
    require 'konstructor'
  end

  context "when one custom konstructor" do
    let_klass do
      konstructor
      def_alpha
      def_betta
    end

    include_examples "one custom constructor"
  end

  context "when two custom constructors" do
    let_klass(name: :base_klass) do
      konstructor
      def_alpha
    end

    let_klass(inherit: :base_klass) do
      konstructor
      def_betta
    end

    include_examples "two custom constructors"
  end

  context "when two custom constructors and redundant include" do
    let_klass(name: :base_klass) do
      konstructor
      def_alpha
    end

    let_klass(inherit: :base_klass) do
      include Konstructor

      konstructor
      def_betta
    end

    include_examples "two custom constructors"
  end

end