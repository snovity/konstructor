require 'spec_helper'

describe "konstructor when default constructor name" do

  subject { klass }

  context "'new' is used" do
    context "via name before method is defined" do
      let_konstructor_klass do
        konstructor :new
      end

      specify { expect_to_raise Konstructor::ReservedNameError }
    end

    context "via next method when method will be defined" do
      let_konstructor_klass do
        konstructor
        def new
          # do nothing
        end
      end

      specify { expect_to_raise Konstructor::ReservedNameError }
    end
  end

  context "'initialize' is used" do
    context "via name after method is defined" do
      let_konstructor_klass do
        konstructor :initialize
      end

      specify { expect_to_raise Konstructor::ReservedNameError }
    end

    context "via next method when method will be redifined" do
      let_konstructor_klass do
        konstructor
        def initialize
          # do nothing
        end
      end

      specify { expect_to_raise Konstructor::ReservedNameError }
    end
  end

end

