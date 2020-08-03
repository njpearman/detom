# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','detom','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'detom'
  s.version = Detom::VERSION
  s.author = 'NJ Pearman'
  s.email = 'n.pearman@gmail.com'
  s.homepage = 'https://github.com/njpearman/detom'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A minimal command line time tracker for individuals'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.extra_rdoc_files = ['README.rdoc','detom.rdoc']
  s.rdoc_options << '--title' << 'detom' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'detom'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rspec')
  s.add_runtime_dependency('gli','2.19.0')
end
