module Ddr
  module Antivirus
    module Adapters
      #
      # Abstract class for scanner adapters.
      # 
      class ScannerAdapter

        def scan(path)
          raise NotImplementedError
        end

        def config
          Ddr::Antivirus.adapter_config
        end

      end
    end
  end
end
