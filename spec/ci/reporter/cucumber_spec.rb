require File.dirname(__FILE__) + "/../../spec_helper.rb"
require 'ci/reporter/cucumber'

module CI::Reporter
  describe Cucumber do
    let(:step_mother) { double("step_mother") }
    let(:io) { double("io") }
    let(:report_manager) { double("report_manager") }

    before :each do
      allow(CI::Reporter::ReportManager).to receive(:new).and_return(report_manager)
    end

    def new_instance
      CI::Reporter::Cucumber.new(step_mother, io, {})
    end

    it "creates a new report manager" do
      expect(CI::Reporter::ReportManager).to receive(:new)
      new_instance
    end

    it "records the feature name of a new feature" do
      cucumber = new_instance
      cucumber.feature_name(nil, "Some feature name")
      expect(cucumber.name).to eql "Some feature name"
    end

    it "records only the first line of a feature name" do
      cucumber = new_instance
      cucumber.feature_name(nil, "Some feature name\nLonger description")
      expect(cucumber.name).to eql "Some feature name"
    end

    context "applied to a feature" do
      let(:cucumber) { new_instance }
      let(:test_suite) { double("test_suite", start: nil, finish: nil, :name= => nil) }
      let(:feature) { double("feature") }

      before :each do
        cucumber.feature_name(nil, "Demo feature")
        allow(CI::Reporter::TestSuite).to receive(:new).and_return(test_suite)
        allow(report_manager).to receive(:write_report)
      end

      context "before" do
        it "creates a new test suite" do
          expect(CI::Reporter::TestSuite).to receive(:new).with(/Demo feature/)
          cucumber.before_feature(feature)
        end

        it "indicates that the test suite has started" do
          expect(test_suite).to receive(:start)
          cucumber.before_feature(feature)
        end
      end

      context "after" do
        let(:cucumber) { new_instance }
        let(:test_suite) { double("test_suite", start: nil, finish: nil, :name= => nil) }
        let(:feature) { double("feature") }

        before :each do
          cucumber.feature_name(nil, "Demo feature")
          allow(CI::Reporter::TestSuite).to receive(:new).and_return(test_suite)
          allow(report_manager).to receive(:write_report)
          cucumber.before_feature(feature)
        end

        it "indicates that the test suite has finished" do
          expect(test_suite).to receive(:finish)
          cucumber.after_feature(feature)
        end

        it "asks the report manager to write a report" do
          expect(report_manager).to receive(:write_report).with(test_suite)
          cucumber.after_feature(feature)
        end
      end
    end

    context "inside a scenario" do
      let(:testcases) { [] }
      let(:test_suite) { double("test_suite", testcases: testcases) }
      let(:cucumber) { new_instance }
      let(:test_case) { double("test_case", start: nil, finish: nil, name: "Step Name") }
      let(:scenario) { double("scenario") }
      let(:step) { double("step", :status => :passed, name: "Step Name") }

      before :each do
        allow(cucumber).to receive(:test_suite).and_return(test_suite)
        allow(CI::Reporter::TestCase).to receive(:new).and_return(test_case)
        cucumber.before_feature_element(scenario)

        allow(cucumber).to receive(:feature_element_type).and_return(:scenario)
      end

      after :each do
        cucumber.after_feature_element(scenario)
      end

      context "before steps" do
        it "creates a new test case" do
          expect(CI::Reporter::TestCase).to receive(:new).with("Step Name")
          cucumber.scenario_name(nil, "Step Name")
          cucumber.before_steps(step)
        end

        it "indicates that the test case has started" do
          expect(test_case).to receive(:start)
          cucumber.before_steps(step)
        end
      end

      context "after steps" do
        before :each do
          allow(cucumber).to receive(:treat_pending_as_failure?).and_return(false)
          cucumber.before_steps(step)
          allow(test_case).to receive(:name=)
          allow(test_case).to receive(:skipped=)
        end

        it "indicates that the test case has finished" do
          expect(test_case).to receive(:finish)
          cucumber.after_steps(step)
        end

        it "adds the test case to the suite's list of cases" do
          expect(testcases).to be_empty
          cucumber.after_steps(step)
          expect(testcases).to_not be_empty
          expect(testcases.first).to eql test_case
        end

        context "a pending test" do
          before { allow(step).to receive(:status).and_return(:pending) }

          it "alters the name of a test case that is pending to include '(PENDING)'" do
            expect(test_case).to receive(:name=).with("Step Name (PENDING)")
            cucumber.after_steps(step)
          end

          it "marks the test case as skipped" do
            expect(test_case).to receive(:skipped=).with(true)
            cucumber.after_steps(step)
          end
        end

        context "an undefined test" do
          before { allow(step).to receive(:status).and_return(:undefined) }

          it "alters the name of a test case that is undefined to include '(PENDING)'" do
            expect(test_case).to receive(:name=).with("Step Name (PENDING)")
            cucumber.after_steps(step)
          end

          it "marks the test case as skipped" do
            expect(test_case).to receive(:skipped=).with(true)
            cucumber.after_steps(step)
          end
        end

        context "a skipped test" do
          before { allow(step).to receive(:status).and_return(:skipped) }

          it "alters the name of a test case that was skipped to include '(SKIPPED)'" do
            expect(test_case).to receive(:name=).with("Step Name (SKIPPED)")
            cucumber.after_steps(step)
          end

          it "marks the test case as skipped" do
            expect(test_case).to receive(:skipped=).with(true)
            cucumber.after_steps(step)
          end
        end

        context "when treating undefined/pending steps as failures" do
          let(:failures) { [] }
          let(:cucumber_failure) { double("cucumber_failure") }

          before :each do
            allow(cucumber).to receive(:treat_pending_as_failure?).and_return(true)
            allow(test_case).to receive(:failures).and_return(failures)
            allow(CI::Reporter::CucumberFailure).to receive(:new).and_return(cucumber_failure)
          end

          it "creates a new cucumber failure with a pending step" do
            allow(step).to receive(:status).and_return(:pending)
            expect(failures).to be_empty
            cucumber.after_steps(step)
            expect(failures).to_not be_empty
            expect(failures.first).to eql cucumber_failure
          end

          it "creates a new cucumber failure with an undefined step" do
            allow(step).to receive(:status).and_return(:undefined)
            expect(failures).to be_empty
            cucumber.after_steps(step)
            expect(failures).to_not be_empty
            expect(failures.first).to eql cucumber_failure
          end
        end
      end

      describe "that fails" do
        let(:failures) { [] }
        let(:cucumber_failure) { double("cucumber_failure") }

        before :each do
          allow(step).to receive(:status).and_return(:failed)
          allow(test_case).to receive(:failures).and_return(failures)
          cucumber.before_steps(step)
          allow(CI::Reporter::CucumberFailure).to receive(:new).and_return(cucumber_failure)
        end

        it "creates a new cucumber failure with that step" do
          expect(CI::Reporter::CucumberFailure).to receive(:new).with(step)
          cucumber.after_steps(step)
        end

        it "adds the failure to the suite's list of failures" do
          expect(failures).to be_empty
          cucumber.after_steps(step)
          expect(failures).to_not be_empty
          expect(failures.first).to eql cucumber_failure
        end
      end
    end

    context "inside a scenario outline" do
      let(:testcases) { [] }
      let(:test_suite) { double("test_suite", testcases: testcases) }
      let(:cucumber) { new_instance }
      let(:test_case) { double("test_case", start: nil, finish: nil, name: "Step Name") }
      let(:scenario_outline) { double("scenario_outline") }
      let(:step_collection) { double("step_collection") }

      before :each do
        allow(cucumber).to receive(:test_suite).and_return(test_suite)
        allow(CI::Reporter::TestCase).to receive(:new).and_return(test_case)

        cucumber.before_feature_element(scenario_outline)
        cucumber.scenario_name(nil, "Scenario Name")

        allow(cucumber).to receive(:feature_element_type).and_return(:scenario_outline)
      end

      after :each do
        cucumber.after_feature_element(scenario_outline)
      end

      context "before steps" do
        it "does not create a new test case" do
          expect(CI::Reporter::TestCase).to_not receive(:new)
          cucumber.before_steps(step_collection)
        end
      end

      context "processing a data table" do
        let(:table_row) { double("table_row", name: "Table Row Name") }

        describe "before table row" do
          it "does not create a new test case" do
            expect(CI::Reporter::TestCase).to_not receive(:new)
            cucumber.before_table_row(table_row)
          end
        end
      end

      context "processing an examples table" do
        let(:table_row) do
          double("table_row", name: "Table Row Name", scenario_outline: scenario_outline)
        end
        let(:expected_test_case_name) { "Scenario Name (outline: Table Row Name)" }

        describe "before table row" do
          it "creates a new test case" do
            expect(CI::Reporter::TestCase).to receive(:new).with(expected_test_case_name)
            cucumber.before_table_row(table_row)
          end
        end
      end
    end

  end
end
