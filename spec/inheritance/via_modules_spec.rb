require 'spec_helper'
require_relative '../shared'
require 'active_support/concern'

describe "konstructor via modules" do

  context "without ActiveSupport::Concern" do
    let(:some_module) do
      Module.new do
        def self.name
          'SomeModule'
        end

        include Konstructor
      end
    end

    subject { some_module }

    specify { expect_to_raise Konstructor::IncludeInModuleError }
  end

  context "with ActiveSupport::Concern" do
    context "and konstructor via names" do
      let(:some_module) do
        Module.new do
          extend ActiveSupport::Concern

          included do
            include Konstructor

            konstructor :betta
          end

          def betta(three)
            @three = three
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
            include Konstructor

            konstructor
            def betta(three)
              @three = three
            end
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