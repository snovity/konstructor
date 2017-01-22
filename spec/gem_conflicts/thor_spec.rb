require 'spec_helper'
require_relative '../shared'
require 'korolev/core_ext'

describe "Korolev.konstructor included when ActiveSupport::Concern" do

  let(:base_class) { Thor }

  let_klass(inherit: :base_class) do
    konstructor
    def_alpha

    no_commands do
      def_betta
    end

    desc 'com1', 'Just a test'
    def comone(oh)
      "received #{oh}"
    end
  end

  specify do

  end

  include_examples "one custom constructor"

end