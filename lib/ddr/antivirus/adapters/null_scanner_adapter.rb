require_relative "scanner_adapter"
require_relative "scan_result"

module Ddr
  module Antivirus
    module Adapters
      #
      # The NullScannerAdapter provides a no-op adapter, primarily for testing and development.
      #
      class NullScannerAdapter < ScannerAdapter

        def scan(path)
          NullScanResult.new("#{path}: NOT SCANNED - using :null scanner adapter.", path)
        end

      end

      #
      # The result of the scan with the NullScannerAdapter.
      #
      class NullScanResult < ScanResult; end

    end
  end
end
