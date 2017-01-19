module CoreHelpers

  def expect_no_method_error
    expect { subject }.to raise_error(NoMethodError)
  end

  def expect_instance_state(*args)
    expect([instance.zero, instance.one, instance.two, instance.three]).to eq args
  end

end
