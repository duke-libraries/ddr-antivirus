require_relative "scan_result"

module Ddr::Antivirus
  #
  # @abstract Subclass and override {#scan} to implement a scanner adapter.
  #
  class ScannerAdapter

    # Scan a file path for viruses.
    #
    # @param path [String] file path to scan.
    # @return [Ddr::Antivirus::ScanResult] the result of the scan.
    def scan(path)
      raise NotImplementedError, "Adapters must implement the `scan' method."
    end

    private

    def logger
      Ddr::Antivirus.logger
    end

  end
end
