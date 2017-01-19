
shared_examples "no custom constructors" do

  context "no constructor is defined" do
    subject { klass.alpha(1, 2) }

    specify { expect { subject }.to raise_error(NoMethodError) }
  end

  context "instantiate via default constructor and unaffected alpha method" do
    let(:instance) { klass.new.tap { |i| i.alpha(11, 22) } }

    subject {[ instance.zero, instance.one, instance.two, instance.three ]}

    it { is_expected.to eq [0, 11, 22, nil] }
  end

end
