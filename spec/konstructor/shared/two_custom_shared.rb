
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

  context "call" do
    context "private instance constructor method" do
      let(:instance) { klass.new }

      context "alpha" do
        subject { instance.alpha(1, 2) }

        specify do
          expect_no_method_error
          expect_instance_state 0, nil, nil, nil
        end
      end

      context "betta" do
        subject { instance.betta(3) }

        specify do
          expect_no_method_error
          expect_instance_state 0, nil, nil, nil
        end
      end
    end

    context "DSL konstructor method" do
      subject { klass.konstructor :betta }

      specify { expect_no_method_error }
    end
  end

end