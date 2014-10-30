module Ddr
  module Antivirus
    module Adapters
      #
      # The NullScannerAdapter provides a no-op adapter, primarily for testing and development.
      #
      class NullScannerAdapter < ScannerAdapter

        RESULT = "File not scanned -- using :null scanner adapter."

        def scan(path)
          Ddr::Antivirus.logger.warn(RESULT)
          Ddr::Antivirus::ScanResult.new(RESULT, path)
        end

      end
    end
  end
end
