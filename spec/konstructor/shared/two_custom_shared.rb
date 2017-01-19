
shared_examples "two custom constructors" do

  context "instantiate" do
    subject {[ instance.zero, instance.one, instance.two, instance.three ]}

    context "via alpha constructor" do
      let(:instance) { klass.alpha(1, 2) }

      it { is_expected.to eq [nil, 1, 2, nil] }
    end

    context "via betta constructor" do
      let(:instance) { klass.betta(3) }

      it { is_expected.to eq [nil, nil, nil, 3] }
    end
  end

end