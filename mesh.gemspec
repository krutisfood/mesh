# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','mesh','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'mesh'
  s.version = Mesh::VERSION
  s.author = 'Kurt Gardiner'
  s.email = 'k.a.gardiner@gmail.com'
  #s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'VMWare command line suite'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','mesh.rdoc']
  s.rdoc_options << '--title' << 'mesh' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'mesh'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('mocha')
  s.add_runtime_dependency('gli','2.9.0')
  s.add_runtime_dependency('logger','1.2.8')
  s.add_runtime_dependency('rbvmomi','1.8.1')
end
