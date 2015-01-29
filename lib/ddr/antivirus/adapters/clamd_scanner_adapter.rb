require "fileutils"
require_relative "scanner_adapter"
require_relative "scan_result"

module Ddr
  module Antivirus
    module Adapters
      #
      # Adapter for clamd client (clamdscan)
      #
      class ClamdScannerAdapter < ScannerAdapter

        def scan(path)
          raw = clamdscan(path)
          ClamdScanResult.new(raw, path)
        end

        def clamdscan(path)
          original_mode = File.stat(path).mode
          FileUtils.chmod("a+r", path) unless File.world_readable?(path)
          result = command(path)
          FileUtils.chmod(original_mode, path) if File.stat(path).mode != original_mode
          result
        end

        private

        def command(path)
          `clamdscan --no-summary #{path}`.strip
        end

      end

      #
      # Result of a scan with the ClamdScannerAdapter
      #
      class ClamdScanResult < ScanResult

        def virus_found
          if m = /: ([^\s]+) FOUND$/.match(raw)
            m[1]
          end
        end

        def has_virus?
          raw =~ / FOUND$/
        end

        def error?
          raw =~ / ERROR$/
        end

        def ok?
          raw =~ / OK$/
        end

        def to_s
          "#{raw} (#{version})"
        end

        def default_version
          `sigtool --version`.strip
        end

      end

    end
  end
end
