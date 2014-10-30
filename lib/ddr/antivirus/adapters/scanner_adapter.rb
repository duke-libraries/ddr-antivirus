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

      end
    end
  end
end
