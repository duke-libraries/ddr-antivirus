module Ddr
  module Antivirus
    module Adapters
      #
      # Abstract class for scanner adapters.
      # 
      class ScannerAdapter

        # Scan a file path for viruses - subclasses must implement.
        #
        # @param [String] file path to scan
        # @return [Ddr::Antivirus::ScanResult] the result
        def scan(path)
          raise NotImplementedError
        end

        # Return the adapter configuration options
        def config
          Ddr::Antivirus.adapter_config
        end

      end
    end
  end
end
