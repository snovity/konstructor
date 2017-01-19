
shared_examples "no custom constructors" do

  context "no constructor is defined" do
    subject { klass.alpha(1, 2) }

    specify { expect_no_method_error }
  end

  context "instantiate via default constructor and unaffected alpha method" do
    let(:instance) { klass.new.tap { |i| i.alpha(11, 22) } }

    specify { expect_instance_state 0, 11, 22, nil }
  end

end
