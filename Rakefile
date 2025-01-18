require 'rake'
require 'parallel'
require 'rspec/core/rake_task'
require 'thread'
require 'yaml'

ENV["TASK_ID"] = '0'
RSpec::Core::RakeTask.new(:single) do |t|
  ENV['CONFIG_NAME'] ||= "single"
  t.pattern = Dir.glob('spec/Test_Script.rb')
  t.rspec_opts = '--format documentation'
  t.verbose = false
end

task :default => :single

RSpec::Core::RakeTask.new(:local) do |t|
	ENV['CONFIG_NAME'] = "local"
	t.pattern = Dir.glob('spec/Test_Script.rb')
	t.rspec_opts = '--format documentation'
	t.verbose = false
end

task :parallel do 
   CONFIG = YAML.load(File.read(File.join(File.dirname(__FILE__), "/config/parallel.config.yml")))
@num_parallel = CONFIG.size

  thread = @num_parallel.times.map do |i|
		Thread.new do
			ENV["TASK_ID"] = (i - 1).to_s
			ENV['name'] = "parallel_test_#{i.to_s}"
			ENV['CONFIG_NAME'] = "parallel"
			Rake::Task["single"].execute
		end
	end
	thread.each(&:join)
	
end
task :test do |t, args|
  Rake::Task["single"].invoke
  Rake::Task["single"].reenable
  Rake::Task["local"].invoke
end