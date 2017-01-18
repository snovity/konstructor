# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'korolev/version'

Gem::Specification.new do |spec|
  spec.name          = 'korolev'
  spec.version       = Korolev::VERSION
  spec.authors       = ['Dima Lashkov']
  spec.email         = ['dm.lashkov@gmail.com']

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  # few paragraphs with no examples or formatting
  spec.description   = %q{Write a longer description or delete this line.}
  # put here link to GitHub repo
  spec.homepage      = 'https://github.com/snovity'
  spec.license       = 'MIT'

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
end
