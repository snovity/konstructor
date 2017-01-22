require 'spec_helper'
require_relative '../shared'
require 'konstructor/core_ext'

describe "Konstructor with constructor" do

  let_klass(skip_initialize: true) do
    konstructor
    def_alpha

    constructor :zero, :three, :four, accessors: true
  end

  context "via Konstructor" do
   let(:instance) { klass.alpha(1, 2) }

   specify { expect_instance_state nil, 1, 2, nil }
  end

  context "via constructor" do
    let(:instance) { klass.new(zero: 0, three: 333, four: 4) }

    specify do
      expect_instance_state 0, nil, nil, 333
      expect(instance.four).to eq 4
    end
  end

end