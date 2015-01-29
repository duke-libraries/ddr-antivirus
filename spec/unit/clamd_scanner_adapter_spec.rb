require "shared_examples_for_scan_results"
require "ddr/antivirus/adapters/clamd_scanner_adapter"

module Ddr
  module Antivirus
    module Adapters
      RSpec.describe ClamdScannerAdapter do

        let(:path) { File.expand_path(File.join("..", "..", "fixtures", "blue-devil.png"), __FILE__) }
        let(:adapter) { described_class.new }

        describe "permissions" do
          before do
            @file = Tempfile.new("test")
            @file.write("Scan me!")
            @file.close
            allow(adapter).to receive(:command).with(@file.path) { "#{@file.path}: OK" }
          end
          after { @file.unlink }
          describe "when the file is not world readable" do
            it "should temporarily change the permissions" do
              original_mode = File.stat(@file.path).mode
              expect(FileUtils).to receive(:chmod).with("a+r", @file.path)
              adapter.scan(@file.path)
              expect(File.stat(@file.path).mode).to eq(original_mode)
            end
          end
          describe "when the file is world readable" do
            before { FileUtils.chmod("a+r", @file.path) }
            it "should not change the permissions" do
              original_mode = File.stat(@file.path).mode
              expect(FileUtils).not_to receive(:chmod)
              adapter.scan(@file.path)
              expect(File.stat(@file.path).mode).to eq(original_mode)
            end
          end
        end

        describe "result" do
          subject { adapter.scan(path) }

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
