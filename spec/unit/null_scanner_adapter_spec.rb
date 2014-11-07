require "shared_examples_for_scan_results"
require "ddr/antivirus/adapters/null_scanner_adapter"

module Ddr
  module Antivirus
    module Adapters
      RSpec.describe NullScannerAdapter do

        let(:path) { File.expand_path(File.join("..", "..", "fixtures", "blue-devil.png"), __FILE__) }

        describe "result" do
          subject { adapter.scan(path) }
          let(:adapter) { described_class.new }
          it "should be a NullScanResult" do
            expect(subject).to be_a(Ddr::Antivirus::Adapters::NullScannerAdapter::NullScanResult)
          end
          it_should_behave_like "a scan result"
          it_should_behave_like "a successful scan result"
        end

      end
    end
  end
end
