require "active_support/dependencies/autoload"

module Ddr
  module Antivirus
    module Adapters
      extend ActiveSupport::Autoload

      autoload :ScannerAdapter
      autoload :NullScannerAdapter
      autoload :ClamavScannerAdapter if Ddr::Antivirus.clamav_installed?

      def self.get_adapter
        klass = self.const_get(adapter_name.to_sym, false)
        klass.new
      end

      def self.adapter_name
        "#{Ddr::Antivirus.scanner_adapter.to_s.capitalize}ScannerAdapter"
      end

    end
  end
end
