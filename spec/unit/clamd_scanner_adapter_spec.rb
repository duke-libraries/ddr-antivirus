require "tempfile"
require "fileutils"
require "ddr/antivirus/adapters/clamd_scanner_adapter"

module Ddr::Antivirus
  RSpec.describe ClamdScannerAdapter do

    before do
      allow(subject).to receive(:version) { "version" }
      allow(subject).to receive(:config) do
        <<-EOS
MaxScanSize = "104857600"
MaxFileSize = "26214400"
MaxRecursion = "16"
MaxFiles = "10000"
EOS
      end
    end

    its(:max_file_size) { is_expected.to eq(26214400) }

    describe "#scan" do
      describe "file size" do
        let(:path) { File.expand_path(File.join("..", "..", "fixtures", "blue-devil.png"), __FILE__) }
        describe "when max file size is not set or unknown" do
          before do
            allow(subject).to receive(:max_file_size) { nil }
          end
          it "scans the file" do
            expect { subject.scan(path) }.not_to raise_error
          end
        end
        describe "when max file size is greater than the size of the file to be scanned" do
          before do
            allow(subject).to receive(:max_file_size) { File.size(path) + 1 }
          end
          it "scans the file" do
            expect { subject.scan(path) }.not_to raise_error
          end
        end
        describe "when max file size is equal to the size of the file to be scanned" do
          before do
            allow(subject).to receive(:max_file_size) { File.size(path) }
          end
          it "scans the file" do
            expect { subject.scan(path) }.not_to raise_error
          end
        end
        describe "when max file size is less than the size of the file to be scanned" do
          before do
            allow(subject).to receive(:max_file_size) { File.size(path) - 1 }
          end
          it "raises an exception" do
            expect { subject.scan(path) }.to raise_error(MaxFileSizeExceeded)
          end
        end
      end

      describe "permissions" do
        before do
          @file = Tempfile.new("test")
          @file.write("Scan me!")
          @file.close
          FileUtils.chmod(0000, @file.path)
        end
        after { @file.unlink }
        describe "when the file is not readable" do
          it "scans the file" do
            expect { subject.scan(@file.path) }.not_to raise_error
          end
          it "resets the original permissions" do
            expect { subject.scan(@file.path) }.not_to change { File.stat(@file.path).mode }
          end
        end
      end

      describe "result" do
        let(:path) { File.expand_path(File.join("..", "..", "fixtures", "blue-devil.png"), __FILE__) }
        before do
          allow(subject).to receive(:clamdscan).with(path) { ["output", exitcode] }
        end
        describe "when a virus is found" do
          let(:exitcode) { 1 }
          it "should raise a VirusFoundError" do
            expect { subject.scan(path) }.to raise_error(VirusFoundError)
          end
        end
        describe "when there is an error" do
          let(:exitcode) { 2 }
          it "raises a ScannerError" do
            expect { subject.scan(path) }.to raise_error(ScannerError)
          end
        end
        describe "success" do
          let(:exitcode) { 0 }
          it "has output" do
            expect(subject.scan(path).output).to eq("output")
          end
          it "has a scanned_at time" do
            expect(subject.scan(path).scanned_at).to be_a(Time)
          end
          it "has a version" do
            expect(subject.scan(path).version).to eq("version")
          end
          it "has the file_path" do
            expect(subject.scan(path).file_path).to eq(path)
          end
        end
      end
    end
  end
end
