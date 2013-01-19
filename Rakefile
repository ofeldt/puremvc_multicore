require 'bundler/gem_tasks'
require 'rake'
require 'pathname'
require 'yard'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

YARD::Rake::YardocTask.new('doc')

desc "Removes temporary project files"
task :clean do
  %w{doc coverage pkg .yardoc Gemfile.lock}.map{ |name| Pathname.new(name) }.each do |path|
    path.rmtree if path.exist?
  end

  Pathname.glob('*.gem').each &:delete
end

desc "Opens an interactive console with the library loaded"
task :console do
  Bundler.setup
  require 'pry'
  require 'puremvc_multicore'
  Pry.start
end

task :default => :spec
