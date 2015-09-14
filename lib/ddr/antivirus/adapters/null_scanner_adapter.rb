module Ddr::Antivirus
  #
  # A no-op adapter, primarily for testing and development.
  #
  class NullScannerAdapter < ScannerAdapter

    def scan(path)
      ScanResult.new(path, "#{path}: NOT SCANNED - using :null scanner adapter.")
    end

  end

end
