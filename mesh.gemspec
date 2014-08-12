# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','mesh','version.rb'])
Gem::Specification.new do |s| 
  s.name        = 'mesh'
  s.version     = Mesh::VERSION
  s.licenses    = ['MIT']
  s.author      = 'Kurt Gardiner'
  s.email       = 'k.a.gardiner@gmail.com'
  s.homepage    = 'http://github.com/krutisfood/mesh'
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'VMWare command line suite'
  s.description = 'VMWare command line suite, command vmware from the comfort of your own pc!'
  s.files       = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','mesh.rdoc']
  s.rdoc_options << '--title' << 'mesh' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'mesh'
  s.add_development_dependency('rake','10.3.1')
  s.add_development_dependency('rdoc','4.1.1')
  s.add_development_dependency('aruba','0.5.4')
  s.add_development_dependency('mocha','1.0.0')
  s.add_runtime_dependency('gli','2.9.0')
  s.add_runtime_dependency('logger','1.2.8')
  s.add_runtime_dependency('rbvmomi','1.8.1')
  s.add_runtime_dependency('highline','~> 1.6.21')
  s.add_runtime_dependency('nokogiri','1.5.5')
end
