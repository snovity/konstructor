# imitates the way requiring a built gem works
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'konstructor'

# requiring all development dependencies via Bundler,
# but not using Bundler in the runtime code
# to avoid having Bundler as runtime dependency
require 'bundler/setup'
Bundler.require(:development)

Coveralls.wear!

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.color = true

  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  config.include CoreHelpers
  config.extend RspecExtensions

end

