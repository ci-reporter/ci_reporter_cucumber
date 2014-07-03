require File.dirname(__FILE__) + "/../../../spec_helper.rb"
require 'rake'
require 'ci/reporter/test_utils/unit'

describe "ci_reporter ci:setup:cucumber task" do
  include CI::Reporter::TestUtils::Unit

  let(:rake) { Rake::Application.new }

  before(:each) do
    Rake.application = rake
    load CI_REPORTER_LIB + '/ci/reporter/rake/cucumber.rb'
    save_env "CI_REPORTS"
    save_env "CUCUMBER_OPTS"
    ENV["CI_REPORTS"] = "some-bogus-nonexistent-directory-that-wont-fail-rm_rf"
  end
  after(:each) do
    restore_env "CUCUMBER_OPTS"
    restore_env "CI_REPORTS"
    Rake.application = nil
  end

  it "sets ENV['CUCUMBER_OPTS'] to include cucumber formatter args" do
    rake["ci:setup:cucumber"].invoke
    expect(ENV["CUCUMBER_OPTS"]).to match /--format\s+CI::Reporter::Cucumber/
  end

  it "does not set ENV['CUCUMBER_OPTS'] to require cucumber_loader" do
    rake["ci:setup:cucumber"].invoke
    expect(ENV["CUCUMBER_OPTS"]).to_not match /.*--require\s+\S*cucumber_loader.*/
  end

  it "appends to ENV['CUCUMBER_OPTS'] if it already contains a value" do
    ENV["CUCUMBER_OPTS"] = "somevalue".freeze
    rake["ci:setup:cucumber"].invoke
    expect(ENV["CUCUMBER_OPTS"]).to match /somevalue.*\s--format\s+CI::Reporter::Cucumber/
  end
end
