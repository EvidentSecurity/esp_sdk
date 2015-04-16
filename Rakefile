require 'bundler/gem_tasks'
require 'rake/testtask'
load 'lib/tasks/rubocop.rake'
load 'lib/tasks/testing.rake'

Rake::TestTask.new do |task|
  task.libs << 'test'
  task.test_files = FileList['test/*_test.rb', 'test/**/*_test.rb']
end

task default: [:test]
