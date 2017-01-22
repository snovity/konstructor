# coding: utf-8
# TODO: replace with require_relative
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'konstructor/version'

Gem::Specification.new do |spec|
  spec.name          = 'konstructor'
  spec.version       = Konstructor::VERSION
  spec.authors       = ['Dima Lashkov']
  spec.email         = ['dm.lashkov@gmail.com']

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  # few paragraphs with no examples or formatting
  # spec.description   = %q{Write a longer description or delete this line.}
  # put here link to GitHub repo
  spec.homepage      = 'https://github.com/snovity'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.0.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  # the reason to use exe is to distinguish between gem development binaries
  # and gem runtime binaries
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.4'
  spec.add_development_dependency 'activesupport', '~> 4.2'

  # to test conflicts, specifying precise versions since below version 1 and no semver guarantees
  spec.add_development_dependency 'thor', '0.19.4'
  spec.add_development_dependency 'contracts', '0.14.0'
  spec.add_development_dependency 'constructor', '2.0.0'
end
