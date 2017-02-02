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

  config.register_ordering(:global) do |examples|
    gem_conflicts_specs = []
    general_specs = []

    examples.select do |example|
      if example.metadata[:file_path].include?('spec/gem_conflicts')
        gem_conflicts_specs << example
      else
        general_specs << example
      end
    end

    # gem conflicts specs require konstructor core extentions that can't be reverted
    general_specs + gem_conflicts_specs
  end
end

require 'konstructor/no_core_ext'
require 'active_support/concern'