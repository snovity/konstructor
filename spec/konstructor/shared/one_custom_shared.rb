

shared_examples "one custom constructor" do

  context "instantiate" do
    subject {[ instance.zero, instance.one, instance.two, instance.three ]}

    context "via alpha constructor" do
      let(:instance) { klass.alpha(1, 2) }

      it { is_expected.to eq [nil, 1, 2, nil] }
    end

    context "via default constructor and unaffected betta method" do
      let(:instance) { klass.new.tap { |i| i.betta(3) } }

      it { is_expected.to eq [0, nil, nil, 3] }
    end
  end

  context "call" do
    context "non-existant betta constructor" do
      subject { klass.betta(3) }

      specify { expect { subject }.to raise_error(NoMethodError) }
    end

    context "private instance constructor method" do
      let(:instance) { klass.alpha(1, 2) }
      subject { instance.alpha(11, 22) }

      specify do
        expect { subject }.to raise_error(NoMethodError)
        expect(instance.one).to eq 1
        expect(instance.two).to eq 2
      end
    end

    context "DSL konstructor method" do
      subject { klass.konstructor :betta }

      specify do
        expect { subject }.to raise_error(NoMethodError)
      end
    end
  end

end