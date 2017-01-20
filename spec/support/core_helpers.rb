module CoreHelpers

  def expect_to_raise(exception_type)
    expect { subject }.to raise_error(exception_type)
  end

  def expect_no_method_error
    expect_to_raise NoMethodError
  end

  def expect_instance_state(*args)
    expect([instance.zero, instance.one, instance.two, instance.three]).to eq args
  end

end
