require "ddr/antivirus/adapters/scan_result"

module Ddr
  module Antivirus
    RSpec.describe Scanner do

      shared_examples "a scanner" do
        let(:path) { "/tmp/foo" }
        describe "logging" do
          it "should log the result" do
            expect(Ddr::Antivirus.logger).to receive(:info)
            subject.scan(path)
          end
        end
        describe "when a virus is found" do
          before { allow_any_instance_of(Ddr::Antivirus::Adapters::ScanResult).to receive(:has_virus?) { true } }
          it "should raise an execption" do
            expect { subject.scan(path) }.to raise_error
          end
        end
        describe "when a virus is not found" do
          before { allow_any_instance_of(Ddr::Antivirus::Adapters::ScanResult).to receive(:has_virus?) { false } }
          it "should return the scan result" do
            expect(subject.scan(path)).to be_a(Ddr::Antivirus::Adapters::ScanResult)
          end
        end
        describe "when an error occurs in the scanner" do
          before { allow_any_instance_of(Ddr::Antivirus::Adapters::ScanResult).to receive(:error?) { true } }
          it "should log an error" do
            expect(Ddr::Antivirus.logger).to receive(:error)
            subject.scan(path)
          end
        end
      end

      before do
        @original_adapter = Ddr::Antivirus.scanner_adapter
        Ddr::Antivirus.scanner_adapter = :null
      end

      after do
        Ddr::Antivirus.scanner_adapter = @original_adapter
      end

      describe ".scan" do
        subject { described_class }
        it_behaves_like "a scanner"
      end

      describe "#scan" do
        subject { described_class.new }
        it_behaves_like "a scanner"
      end

    end
  end
end
