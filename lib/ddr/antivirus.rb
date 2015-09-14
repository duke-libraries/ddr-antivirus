require "logger"

require_relative "antivirus/version"
require_relative "antivirus/scanner"
require_relative "antivirus/scan_result"
require_relative "antivirus/scanner_adapter"
require_relative "antivirus/adapters/null_scanner_adapter"

module Ddr
  module Antivirus

    class Error < ::StandardError; end

    class ResultError < Error
      attr_reader :result
      def initialize(result)
        super(result.to_s)
        @result = result
      end
    end

    class VirusFoundError < ResultError; end

    class ScannerError < ResultError; end

    class << self
      attr_accessor :logger, :scanner_adapter

      def configure
        yield self
      end

      def scan(path)
        Scanner.scan(path)
      end

      def scanner
        s = Scanner.new
        block_given? ? yield(s) : s
      end

      def test_mode!
        configure do |config|
          config.logger = Logger.new(File::NULL)
          config.scanner_adapter = :null
        end
      end

      # @return [Class] the scanner adapter class
      def get_adapter
        if scanner_adapter.nil?
          raise Error, "`Ddr::Antivirus.scanner_adapter` is not configured."
        end
        require_relative "antivirus/adapters/#{scanner_adapter}_scanner_adapter"
        adapter_name = scanner_adapter.to_s.capitalize + "ScannerAdapter"
        self.const_get(adapter_name, false)
      end
    end

    self.logger = if defined?(Rails) && Rails.logger
                    Rails.logger
                  else
                    Logger.new(STDERR)
                  end

  end
end
