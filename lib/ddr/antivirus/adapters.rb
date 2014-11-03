require_relative "./adapters/scanner_adapter"

module Ddr
  module Antivirus
    module Adapters

      def self.get_adapter
        require_relative adapter_module
        klass = self.const_get(adapter_name.to_sym, false)
        klass.new
      end

      def self.adapter_name
        "#{Ddr::Antivirus.scanner_adapter.to_s.capitalize}ScannerAdapter"
      end

      def self.adapter_module
        "./adapters/#{Ddr::Antivirus.scanner_adapter}_scanner_adapter"
      end

    end
  end
end
