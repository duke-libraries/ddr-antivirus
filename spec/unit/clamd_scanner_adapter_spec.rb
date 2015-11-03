require "tempfile"
require "fileutils"
require "ddr/antivirus/adapters/clamd_scanner_adapter"

module Ddr::Antivirus
  RSpec.describe ClamdScannerAdapter do

    before do
      allow(subject).to receive(:version) { "version" }
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
