require "bundler/gem_tasks"
require "rake/testtask"
require "rake/extensiontask"

task :kaitai do
  puts "Generating Kaitai Struct Ruby classes from *.ksy files..."
  sh "ksc -t ruby --outdir lib/gprs_kaitai ksy/gprs_command.ksy"
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

spec = Gem::Specification.load('gprs.gemspec')
Rake::ExtensionTask.new('gprs_c', spec)
