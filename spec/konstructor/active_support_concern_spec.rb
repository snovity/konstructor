require 'spec_helper'
require_relative 'shared'
require 'active_support/concern'

describe "Korolev.konstructor included when ActiveSupport::Concern" do

  context "is not used" do
    let(:some_module) do
      Module.new do
        def self.name
          'SomeModule'
        end

        include Korolev
      end
    end

    subject { some_module }

    specify { expect_to_raise Korolev::IncludeInModuleError }
  end

  context "is used" do
    context "and konstructor via names" do
      let(:some_module) do
        Module.new do
          extend ActiveSupport::Concern

          included do
            include Korolev

            konstructor :betta
          end

          attr_reader :zero, :one, :two, :three

          def betta(three)
            @three = three
          end

          def initialize
            @zero = 0
          end
        end
      end

      let_klass(include: :some_module) do
        konstructor
        def_alpha
      end

      include_examples "two custom constructors"
    end

    context "and konstructor via next method" do
      let(:some_module) do
        Module.new do
          extend ActiveSupport::Concern

          included do
            include Korolev

            konstructor
            def betta(three)
              @three = three
            end
          end

          attr_reader :zero, :one, :two, :three

          def initialize
            @zero = 0
          end
        end
      end

      let_klass(include: :some_module) do
        konstructor
        def_alpha
      end

      include_examples "two custom constructors"
    end
  end

end