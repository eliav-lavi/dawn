
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dawn/version"

Gem::Specification.new do |spec|
  spec.name          = "dawn"
  spec.version       = Dawn::VERSION
  spec.authors       = ["Eliav Lavi"]
  spec.email         = ["eliavlavi@gmail.com"]

  spec.summary       = %q{A Object Initialization Utility for Dependency Injection Based Design Purposes}
  spec.description   = %q{A a simple and intuitive instances container for Ruby. Dawn helps in managing re-usable instances in an application, without having to recreate them upon each request. }
  spec.homepage      = "https://github.com/eliav-lavi/dawn"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", '~> 0.12.2'
end
