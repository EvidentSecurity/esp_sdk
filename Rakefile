require 'bundler/gem_tasks'
require 'rake/testtask'
load 'lib/tasks/rubocop.rake'
load 'lib/tasks/testing.rake'
require 'rdoc/task'

Rake::TestTask.new do |task|
  task.libs << 'test'
  task.test_files = FileList['test/*_test.rb', 'test/**/*_test.rb'] - FileList["test/esp/integration/**/*_test.rb"]
end

namespace "test" do
  Rake::TestTask.new("integration") do |t|
    t.pattern = "test/esp/integration/**/*_test.rb"
  end

  Rake::TestTask.new("all") do |task|
    task.libs << 'test'
    task.test_files = FileList['test/*_test.rb', 'test/**/*_test.rb']
  end
end

task default: [:test]

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ESPSDK'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/esp/resources/**/*.rb')
  rdoc.rdoc_files.include('lib/esp/extensions/active_resource/paginated_collection.rb')
  rdoc.rdoc_files.include('lib/esp.rb')
end
