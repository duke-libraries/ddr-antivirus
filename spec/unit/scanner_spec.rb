module Ddr
  module Antivirus
    RSpec.describe Scanner do

      shared_examples "a scanner" do
        describe "when a virus is found" do
          before do
            allow_any_instance_of(ScanResult).to receive(:has_virus?) { true }
          end
          it "should raise an execption" do
            expect { subject.scan("/tmp/foo") }.to raise_error
          end
        end
        describe "when a virus is not found" do
          before do
            allow_any_instance_of(ScanResult).to receive(:has_virus?) { false }
          end
          it "should return the scan result" do
            expect(subject.scan("/tmp/foo")).to be_a(ScanResult)
          end
        end
        describe "when an error occurs in the scanner" do
          before do
            allow_any_instance_of(ScanResult).to receive(:error?) { true }
          end
          it "should log an error" do
            expect(Ddr::Antivirus.logger).to receive(:error)
            subject.scan("/tmp/foo")
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
