require "shared_examples_for_scan_results"
require "ddr/antivirus/adapters/clamd_scanner_adapter"

module Ddr
  module Antivirus
    module Adapters
      RSpec.describe ClamdScannerAdapter do

        let(:path) { File.expand_path(File.join("..", "..", "fixtures", "blue-devil.png"), __FILE__) }

        describe "result" do
          subject { adapter.scan(path) }
          let(:adapter) { described_class.new }
          it "should be a scan result" do
            expect(subject).to be_a(ClamdScanResult)
          end
          it_should_behave_like "a scan result"
          context "when a virus is found" do
            before { allow(adapter).to receive(:clamdscan).with(path) { "#{path}: Bad-boy-35 FOUND" } }
            it "should have a virus_found" do
              expect(subject.virus_found).to eq "Bad-boy-35"
            end
            it_should_behave_like "a virus scan result"
          end
          context "when there is an error" do
            before { allow(adapter).to receive(:clamdscan).with(path) { "#{path}: ERROR" } }
            it "should not have a virus" do
              expect(subject).not_to have_virus
            end
            it_should_behave_like "an error scan result"
          end
          context "success" do
            before { allow(adapter).to receive(:clamdscan).with(path) { "#{path}: OK" } }
            it_should_behave_like "a successful scan result"
          end
        end
      end
    end
  end
end
