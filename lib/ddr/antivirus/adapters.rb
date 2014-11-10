module Ddr
  module Antivirus
    module Adapters

      def self.get_adapter 
        require_relative "adapters/#{Ddr::Antivirus.scanner_adapter}_scanner_adapter"
        adapter_name = "#{Ddr::Antivirus.scanner_adapter.to_s.capitalize}ScannerAdapter"
        klass = self.const_get(adapter_name.to_sym, false)
        klass.new
      end

    end
  end
end
