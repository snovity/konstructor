require 'spec_helper'
require_relative '../shared'
require 'korolev/core_ext'

describe "Korolev with Thor" do

  let(:base_class) { Thor }

  let_klass(inherit: :base_class, skip_initialize: true) do
    konstructor
    def_alpha

    desc 'betta VAL', 'Just a test'
    def betta(three)
      @three = three
      self
    end
  end

  context "via Korolev" do
   let(:instance) { klass.alpha(1, 2) }

   specify { expect_instance_state nil, 1, 2, nil }
  end

  context "via Thor" do
    let(:instance) { klass.new.invoke('betta', ['thornike']) }

    specify { expect_instance_state nil, nil, nil, 'thornike' }
  end

end