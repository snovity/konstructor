require 'spec_helper'

describe "Korolev.konstructor when block is given" do

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

