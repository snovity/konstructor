require 'spec_helper'

describe "Korolev.konstructor" do

  context "when block is given" do
    let_korolev_klass do
      konstructor
      def alpha(one, two)
        @one, @two = one, two
        @three = yield one + two
      end
    end

    context "via alpha constructor" do
      let(:instance) { klass.alpha(1, 2) { |sum| sum * 3 } }

      specify { expect_instance_state nil, 1, 2, 9 }
    end
  end

  context "when default constructor name" do
    subject { klass }

    context "'new' is used" do
      context "via name before method is defined" do
        let_korolev_klass do
          konstructor :new
        end

        specify { expect_to_raise Korolev::DefaultConstructorError }
      end

      context "via next method when method will be defined" do
        let_korolev_klass do
          konstructor
          def new
            # do nothing
          end
        end

        specify { expect_to_raise Korolev::DefaultConstructorError }
      end
    end

    context "'initialize' is used" do
      context "via name after method is defined" do
        let_korolev_klass do
          konstructor :initialize
        end

        specify { expect_to_raise Korolev::DefaultConstructorError }
      end

      context "via next method when method will be redifined" do
        let_korolev_klass do
          konstructor
          def initialize
            # do nothing
          end
        end

        specify { expect_to_raise Korolev::DefaultConstructorError }
      end
    end
  end

end

