require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :test

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs = ['test', 'fixtures']
  t.test_files = ['test/test_filmbuff.rb',
                  'test/filmbuff/test_filmbuff_title.rb'
                 ]
end
