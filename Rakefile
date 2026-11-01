# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

# Offline unit tests. They run against a local stub server and never call the Copyleaks API.
Rake::TestTask.new(:test) do |t|
  t.libs << 'test' << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = false
end

task default: %i[test]
