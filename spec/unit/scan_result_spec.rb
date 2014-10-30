require 'shared_examples_for_scan_results'

module Ddr
  module Antivirus
    RSpec.describe ScanResult do
      subject { described_class.new("Raw result", "/tmp/foo") }

      it_should_behave_like "a scan result"

      describe "success" do
        it_should_behave_like "a successful scan result"        
      end

      describe "error" do
        before { allow(subject).to receive(:error?) { true } }
        it_should_behave_like "an error scan result"
      end

      describe "virus found" do
        before { allow(subject).to receive(:virus_found) { "Bad boy 35" } }
        it_should_behave_like "a virus scan result"
      end
    end
  end
end
