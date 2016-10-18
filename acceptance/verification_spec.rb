require 'rexml/document'
require 'ci/reporter/test_utils/accessor'
require 'ci/reporter/test_utils/shared_examples'
require 'rspec/collection_matchers'

REPORTS_DIR = File.dirname(__FILE__) + '/reports'

describe "Cucumber acceptance" do
  include CI::Reporter::TestUtils::SharedExamples
  Accessor = CI::Reporter::TestUtils::Accessor

  let(:report_path) { File.join(REPORTS_DIR, 'FEATURES-Example-Cucumber-feature.xml') }

  describe "the feature" do
    subject(:result) { Accessor.new(load_xml_result(report_path)) }

    it { is_expected.to have(0).errors }
    it { expect(result.skipped_count).to be 1 }
    it { is_expected.to have(2).failures }
    it { is_expected.to have(7).testcases }

    it_behaves_like "a report with consistent attribute counts"
    it_behaves_like "assertions are not tracked"
    it_behaves_like "nothing was output"

    describe "the test the lazy hacker wrote" do
      subject(:testcase) { result.testcase('Lazy hacker') }

      it { is_expected.to have(1).failures }

      describe "the failure" do
        subject(:failure) { testcase.failures.first }

        it "has a type" do
          expect(failure.type).to match /ExpectationNotMetError/
        end
      end
    end

    describe "the test the forgetful hacker wrote" do
      subject(:testcase) { result.testcase('Forgetful hacker (PENDING)') }

      it { is_expected.to be_skipped }
    end

    describe "the test the bad coder wrote" do
      subject(:testcase) { result.testcase('Bad coder') }

      it { is_expected.to have(1).failures }

      describe "the failure" do
        subject(:failure) { testcase.failures.first }

        it "has a type" do
          expect(failure.type).to match /RuntimeError/
        end
      end
    end

    describe "the test that uses a data table" do
      subject(:testcase) { result.testcase('Using a data table in a scenario') }

      it { is_expected.to have(0).failures }
    end

    context "the scenario outline with an examples table" do

      let(:scenario_name) { 'Using a scenario outline' }
      let(:example_1_string) { '| Example Cell A | Example Cell B | Example Cell C |' }
      let(:example_2_string) { '| Example Cell D | Example Cell E | Example Cell F |' }

      describe "the first example in the table" do
        subject(:testcase) {
          result.testcase("#{scenario_name} (outline: #{example_1_string})")
        }

        it { is_expected.to have(0).failures }
      end

      describe "the second example in the table" do
        subject(:testcase) {
          result.testcase("#{scenario_name} (outline: #{example_2_string})")
        }

        it { is_expected.to have(0).failures }
      end
    end
  end

  def load_xml_result(path)
    File.open(path) do |f|
      REXML::Document.new(f)
    end
  end
end
