require File.dirname(__FILE__) + "/../../spec_helper.rb"
require 'ci/reporter/cucumber'

module CI::Reporter
  describe CucumberFailure do
    let(:klass) { double("class", name: "Exception name") }
    let(:exception) do
      double("exception",
             class: klass,
             message: "Exception message",
             backtrace: ["First line", "Second line"])
    end
    let(:step) { double("step", exception: exception) }

    subject(:cucumber_failure) { CucumberFailure.new(step) }

    it "is always a failure" do
      expect(cucumber_failure).to be_failure
    end

    it "is never an error" do
      expect(cucumber_failure).to_not be_error
    end

    it "uses the exception's class name as the name" do
      expect(cucumber_failure.name).to eql "Exception name"
    end

    it "uses the exception's message as the message" do
      expect(cucumber_failure.message).to eql "Exception message"
    end

    it "formats the exception's backtrace" do
      expect(cucumber_failure.location).to eql "First line\nSecond line"
    end
  end
end
