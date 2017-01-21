require_relative 'shared/no_custom_shared'
require_relative 'shared/one_custom_shared'
require_relative 'shared/two_custom_shared'

def expect_working_module
  expect(klass.test_methods).to eq [:alphaman, :bettaman]
end