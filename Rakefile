require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.version = "0.1"
  gem.name = "boxgrinder-ovfcatalog-delivery-plugin"
  gem.homepage = "http://github.com/abiquo/boxgrinder-ovfcatalog-delivery-plugin"
  gem.license = "MIT"
  gem.summary = %Q{Deliver Boxgrider appliances to Abiquo OVFCatalog service}
  gem.description = %Q{Deliver Boxgrider appliances to Abiquo OVFCatalog service}
  gem.email = "rubiojr@frameos.org"
  gem.authors = ["Sergio Rubio"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency 'diskid'
  gem.add_runtime_dependency 'curb'
  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :build

