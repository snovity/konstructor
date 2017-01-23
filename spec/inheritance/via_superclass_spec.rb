require 'spec_helper'
require_relative '../shared'

describe "Konstructor.konstructor via superclass" do

  context "when no custom constructors" do
    let_konstructor_klass(name: :base_klass) do
      def_alpha
    end

    let_klass(inherit: :base_klass) do
      def_betta
    end

    include_examples "no custom constructors"
  end

  context "inherited methods marked as constructors in subclass" do
    subject { klass }

    context "when Konstructor is included in base class" do
      let_konstructor_klass(name: :base_klass) do
        def_alpha
        def_betta
      end

      let_klass(inherit: :base_klass) do
        konstructor :alpha, :betta
      end

      specify { expect_to_raise Konstructor::DeclaringInheritedError }
    end

    context "when Konstructor is included in subclass" do
      let_klass(name: :base_klass) do
        def_alpha
        def_betta
      end

      let_konstructor_klass(inherit: :base_klass) do
        konstructor :alpha, :betta
      end

      specify { expect_to_raise Konstructor::DeclaringInheritedError }
    end
  end

  context "inherited method overriden and marked as constructor in subclass" do
    let_konstructor_klass(name: :base_klass) do
      def_alpha
      def_betta
    end

    subject { klass }

    context "via name" do
      let_klass(inherit: :base_klass) do
        konstructor :alpha
        def_alpha
      end

      specify { expect_to_raise Konstructor::DeclaringInheritedError }
    end

    context "via next method" do
      let_klass(inherit: :base_klass) do
        konstructor
        def_alpha
      end

      specify { expect_to_raise Konstructor::DeclaringInheritedError }
    end
  end

  context "when constructor from subclass reuses method from superclass" do
    let_konstructor_klass(name: :base_klass) do
      def_betta
    end

    let(:instance) { klass.alpha(1, 2) }

    context "via name" do
      let_klass(inherit: :base_klass) do
        konstructor :alpha
        def alpha(one, two)
          betta(one - two)
        end
      end

      specify { expect_instance_state nil, nil, nil, -1 }
    end

    context "via next method" do
      let_klass(inherit: :base_klass) do
        konstructor
        def alpha(one, two)
          betta(one - two)
        end
      end

      specify { expect_instance_state nil, nil, nil, -1 }
    end
  end

  context "when one custom constructor is inherited from base class" do
    let_konstructor_klass(name: :base_klass) do
      konstructor
      def_alpha
      def_betta
    end

    let_klass(inherit: :base_klass)

    include_examples "one custom constructor"
  end

  context "when one custom constructor from base class is overriden" do
    let_konstructor_klass(name: :base_klass) do
      konstructor
      def_alpha
      def_betta
    end

    context "and modifies arguments for subclass" do
      let_klass(inherit: :base_klass) do
        def alpha(one, two)
          super(one * 2, two * 2)
        end
      end

      let(:instance) { klass.alpha(1, 2) }

      specify { expect_instance_state nil, 2, 4, nil }
    end

    context "and sets another variable" do
      let_klass(inherit: :base_klass) do
        def alpha(one, two)
          @minus_one = -1
          super
        end
      end

      include_examples "one custom constructor"
    end
  end

  context "when two custom constructors are inherited from base class" do
    let_konstructor_klass(name: :base_klass) do
      konstructor :alpha, :betta
      def_alpha
      def_betta
    end

    let_klass(inherit: :base_klass)

    include_examples "two custom constructors"
  end

end