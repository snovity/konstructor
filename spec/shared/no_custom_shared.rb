
shared_examples "no custom constructors" do

  context "no alpha constructor is defined" do
    subject { klass.alpha(1, 2) }

    specify { expect_no_method_error }
  end

  context "no betta constructor is defined" do
    subject { klass.betta(3) }

    specify { expect_no_method_error }
  end

  context "instantiate via default constructor and unaffected alpha method" do
    let(:instance) { klass.new.tap { |i| i.alpha(11, 22) } }

    specify { expect_instance_state 0, 11, 22, nil }
  end

  context "instantiate via default constructor and unaffected betta method" do
    let(:instance) { klass.new.tap { |i| i.betta(33) } }

    specify { expect_instance_state 0, nil, nil, 33 }
  end

end
