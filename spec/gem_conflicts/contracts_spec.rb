require 'spec_helper'
require_relative '../shared'
require 'konstructor/core_ext'

describe "Konstructor with contracts.ruby" do

  # Contracts seem not to work with any kind of class metaprogramming,
  # so defining regular classes

  context "when contract is for method" do
    class TestContractsOne
      include Contracts::Core
      include Contracts::Builtin

      attr_reader :zero, :one, :two, :three

      def initialize
        @zero = 0
      end

      konstructor
      def alpha(one, two)
        @one, @two = one, two
      end

      Contract Num => Bool
      def betta(three)
        @three = three
        true
      end
    end

    let(:klass) { TestContractsOne }

    include_examples "one custom constructor"

    context "call contracted method" do
      let(:instance) { klass.alpha(111, 222) }

      subject { instance.betta(value) }

      context "with number" do
        let(:value) { 333 }

        specify do
          expect(subject).to eq true
          expect_instance_state nil, 111, 222, 333
        end
      end

      context "with string" do
        let(:value) { 'not a number' }

        specify do
          expect_to_raise ParamContractError
          expect_instance_state nil, 111, 222, nil
        end
      end
    end
  end

  context "when contract is for konstructor after konstructor keyword" do
    class TestContractsTwo
      include Contracts::Core
      include Contracts::Builtin

      attr_reader :zero, :one, :two, :three

      def initialize
        @zero = 0
      end

      konstructor
      def alpha(one, two)
        @one, @two = one, two
      end

      konstructor
      Contract Num => TestContractsTwo
      def betta(three)
        @three = three
      end
    end

    let(:klass) { TestContractsTwo }

    include_examples "two custom constructors"

    context "call contracted method" do
      let(:instance) { klass.betta(value) }

      subject { instance }

      context "with number" do
        let(:value) { 333 }

        specify { expect_instance_state nil, nil, nil, 333 }
      end

      context "with string" do
        let(:value) { 'not a number' }

        specify do
          expect_to_raise ParamContractError
        end
      end
    end
  end

  context "when contract is for konstructor before konstructor keyword" do
    class TestContractsThree
      include Contracts::Core
      include Contracts::Builtin

      attr_reader :zero, :one, :two, :three

      def initialize
        @zero = 0
      end

      konstructor
      def alpha(one, two)
        @one, @two = one, two
      end

      Contract Num => TestContractsThree
      konstructor
      def betta(three)
        @three = three
      end
    end

    let(:klass) { TestContractsThree }

    include_examples "two custom constructors"

    context "call contracted method" do
      let(:instance) { klass.betta(value) }

      subject { instance }

      context "with number" do
        let(:value) { 333 }

        specify { expect_instance_state nil, nil, nil, 333 }
      end

      context "with string" do
        let(:value) { 'not a number' }

        specify do
          expect_to_raise ParamContractError
        end
      end
    end
  end

end