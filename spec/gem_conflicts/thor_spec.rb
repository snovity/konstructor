require 'spec_helper'
require 'konstructor'

describe "Konstructor with Thor" do

  let(:base_class) { Thor }

  shared_examples "compatible Konstructor and Thor" do
    context "via Konstructor" do
     let(:instance) { klass.alpha(1, 2) }

     specify { expect_instance_state nil, 1, 2, nil }
    end

    context "via Thor" do
      let(:instance) { klass.new.invoke('betta', ['thornike']) }

      specify { expect_instance_state nil, nil, nil, 'thornike' }
    end
  end

  context "when konstructor comes before command" do
    let_klass(inherit: :base_class, skip_initialize: true) do
      konstructor
      def_alpha

      desc 'betta VAL', 'Just a test'
      def betta(three)
        @three = three
        self
      end
    end

    include_examples "compatible Konstructor and Thor"
  end

  context "when command comes before konstructor" do
    let_klass(inherit: :base_class, skip_initialize: true) do
      desc 'betta VAL', 'Just a test'
      def betta(three)
        @three = three
        self
      end

      konstructor
      def_alpha
    end

    include_examples "compatible Konstructor and Thor"
  end

end