
shared_examples "two custom constructors" do

  context "instantiate" do
    context "via alpha constructor" do
      let(:instance) { klass.alpha(1, 2) }

      specify { expect_instance_state nil, 1, 2, nil }
    end

    context "via betta constructor" do
      let(:instance) { klass.betta(3) }

      specify { expect_instance_state nil, nil, nil, 3 }
    end
  end

end