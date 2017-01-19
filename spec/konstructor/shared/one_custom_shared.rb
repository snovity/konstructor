

shared_examples "one custom constructor" do

  context "instantiate" do
    context "via alpha constructor" do
      let(:instance) { klass.alpha(1, 2) }

      specify { expect_instance_state nil, 1, 2, nil }
    end

    context "via default constructor and unaffected betta method" do
      let(:instance) { klass.new.tap { |i| i.betta(3) } }

      specify { expect_instance_state 0, nil, nil, 3 }
    end
  end

  context "call" do
    context "non-existant betta constructor" do
      subject { klass.betta(3) }

      specify { expect_no_method_error }
    end

    context "private instance constructor method" do
      let(:instance) { klass.alpha(1, 2) }
      subject { instance.alpha(11, 22) }

      specify do
        expect_no_method_error
        expect_instance_state nil, 1, 2, nil
      end
    end

    context "DSL konstructor method" do
      subject { klass.konstructor :betta }

      specify { expect_no_method_error }
    end
  end

end