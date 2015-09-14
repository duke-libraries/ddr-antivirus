require "tempfile"
require "ddr/antivirus/adapters/clamd_scanner_adapter"

module Ddr::Antivirus
  RSpec.describe ClamdScannerAdapter do

    let(:path) { File.expand_path(File.join("..", "..", "fixtures", "blue-devil.png"), __FILE__) }

    before do
      allow(subject).to receive(:version) { "version" }
    end

    describe "permissions" do
      before do
        @file = Tempfile.new("test")
        @file.write("Scan me!")
        @file.close
        allow(subject).to receive(:command).with(@file.path) { ["#{@file.path}: OK", double(exitstatus: 0)] }
      end
      after { @file.unlink }
      describe "when the file is not world readable" do
        it "should temporarily change the permissions" do
          FileUtils.chmod("a-r", @file.path)
          original_mode = File.stat(@file.path).mode
          expect(FileUtils).to receive(:chmod).with("a+r", @file.path)
          subject.scan(@file.path)
          expect(File.stat(@file.path).mode).to eq(original_mode)
        end
      end
      describe "when the file is world readable" do
        before { FileUtils.chmod("a+r", @file.path) }
        it "should not change the permissions" do
          original_mode = File.stat(@file.path).mode
          expect(FileUtils).not_to receive(:chmod)
          subject.scan(@file.path)
          expect(File.stat(@file.path).mode).to eq(original_mode)
        end
      end
    end

    describe "result" do
      before do
        allow(subject).to receive(:command).with(path) { ["output", status] }
      end
      describe "when a virus is found" do
        let(:status) { double(exitstatus: 1) }
        it "should raise a VirusFoundError" do
          expect { subject.scan(path) }.to raise_error(VirusFoundError)
        end
      end
      describe "when there is an error" do
        let(:status) { double(exitstatus: 2) }
        it "should raise a ScannerError" do
          expect { subject.scan(path) }.to raise_error(ScannerError)
        end
      end
      describe "success" do
        let(:status) { double(exitstatus: 0) }
        it "should have output" do
          expect(subject.scan(path).output).to eq("output")
        end
        it "should have a scanned_at time" do
          expect(subject.scan(path).scanned_at).to be_a(Time)
        end
        it "should have a version" do
          expect(subject.scan(path).version).to eq("version")
        end
        it "should have the file_path" do
          expect(subject.scan(path).file_path).to eq(path)
        end
      end
    end
  end
end
