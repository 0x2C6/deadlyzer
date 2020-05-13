lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deadlyzer/version'

Gem::Specification.new do |spec|
  spec.name          = "deadlyzer"
  spec.version       = Deadlyzer::VERSION
  spec.authors       = ["Farhad"]
  spec.email         = ["farhad9801@gmail.com"]

  spec.summary       = %q{Reveal uncalled constants}
  spec.description   = %q{Scan find unused constant on other directories, compare and remove}
  spec.homepage      = "https://github.com/0x2C6/deadlyzer"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.2.0")

  spec.files         = `git ls-files -c -o --exclude-standard -z -- exe/* lib/* bin/* README.md wt.gemspec`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rake',  '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry-nav'
  spec.add_dependency 'rubocop'
  spec.add_dependency 'coderay'
  spec.add_dependency 'spinning_cursor'
  spec.add_dependency 'corol'
end
