require "shared_examples_for_scan_results"
require "ddr/antivirus/adapters/clamav_scanner_adapter"

module Ddr
  module Antivirus
    module Adapters
      RSpec.describe ClamavScannerAdapter do

        let(:path) { File.expand_path(File.join("..", "..", "fixtures", "blue-devil.png"), __FILE__) }

        describe "#scan" do
          context "when the db is already loaded" do
            before { subject.engine.loaddb }
            it "should reload the db" do
              expect(subject.engine).to receive(:reload).and_call_original
              expect(subject.engine).not_to receive(:loaddb)
              subject.scan(path)
            end
          end
          context "when the db is not already loaded" do
            before { allow(subject.engine).to receive(:reload).and_raise(RuntimeError) }
            it "should load the db" do
              expect(subject.engine).to receive(:loaddb).and_call_original
              subject.scan(path)
            end
          end  
          context "when the db is not reloaded successfully" do
            before { allow(subject.engine).to receive(:reload) { 2 } }
            it "should load the db" do
              expect(subject.engine).to receive(:loaddb).and_call_original
              subject.scan(path)
            end
          end
 
          describe "result" do
            subject { adapter.scan(path) }
            let(:adapter) { described_class.new }
            it "should be a ClamavScanResult" do
              expect(subject).to be_a(ClamavScanResult)
            end
            it_should_behave_like "a scan result"
            context "when a virus is found" do
              before { allow(adapter.engine).to receive(:scanfile).with(path) { "Bad boy 35" } }
              it "the raw result should be the virus description" do
                expect(subject.raw).to eq "Bad boy 35"
                expect(subject.virus_found).to eq "Bad boy 35"
              end
              it_should_behave_like "a virus scan result"
            end
            context "when there is an error" do
              before { allow(adapter.engine).to receive(:scanfile).with(path) { 1 } }
              it "should not have a virus" do
                expect(subject).not_to have_virus
              end
              it_should_behave_like "an error scan result"
            end
            context "success" do
              before { allow(adapter.engine).to receive(:scanfile).with(path) { 0 } }
              it_should_behave_like "a successful scan result"
            end
          end
        end
      end
    end
  end
end
