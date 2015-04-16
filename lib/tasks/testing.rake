# needed to include the coveralls:push rake task used in travis
require 'coveralls/rake/task'
Coveralls::RakeTask.new

Rake::Task["test"].enhance %w(rubocop)
