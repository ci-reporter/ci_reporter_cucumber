require "bundler/gem_tasks"
require 'ci/reporter/internal'
include CI::Reporter::Internal

namespace :generate do
  task :clean do
    rm_rf "acceptance/reports"
  end

  task :cucumber do
    cucumber = "#{Gem.loaded_specs['cucumber'].gem_dir}/bin/cucumber"
    run_ruby_acceptance "-rci/reporter/rake/cucumber_loader -S #{cucumber} --format CI::Reporter::Cucumber acceptance/cucumber"
  end

  task :all => [:clean, :cucumber]
end

task :acceptance => "generate:all"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:acceptance_spec) do |t|
  t.pattern = FileList['acceptance/verification_spec.rb']
  t.rspec_opts = "--color"
end
task :acceptance => :acceptance_spec

RSpec::Core::RakeTask.new(:unit_spec) do |t|
  t.pattern = FileList['spec']
  t.rspec_opts = "--color"
end

task :default => [:unit_spec, :acceptance]
