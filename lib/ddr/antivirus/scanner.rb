require "active_support/core_ext/class/attribute"

module Ddr
  module Antivirus
    class Scanner
      
      # Instance of scanner adapter
      attr_reader :adapter

      def self.scan(path)
        new { |scanner| return scanner.scan(path) }
      end

      def initialize
        @adapter = Ddr::Antivirus::Adapters.get_adapter
        yield self if block_given?
      end

      def scan(path)
        result = adapter.scan(path)
        raise Ddr::Antivirus::VirusFoundError, result if result.has_virus?
        logger.error("Antivirus scanner error (#{result.version})") if result.error?
        logger.info(result)
        result
      end

      private

        def logger
          Ddr::Antivirus.logger
        end

    end
  end
end

