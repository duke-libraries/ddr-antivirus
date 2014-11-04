require 'clamav'

module Ddr
  module Antivirus
    module Adapters
      class ClamavScannerAdapter < ScannerAdapter

        def scan(path)
          reload!
          raw = engine.scanfile(path)
          ClamavScanResult.new(raw, path)
        end

        def reload!
          #
          # ClamAV.instance.reload is supposed to reload the database if changed and return:
          #
          # 0 => unnecessary
          # 1 => successful
          # 2 => error (undocumented)
          #
          # However, reload raises a RuntimeError when the db needs to be reloaded, 
          # in which case, loaddb must be called.
          #
          engine.loaddb unless [0, 1].include?(engine.reload)
        rescue RuntimeError
          engine.loaddb
        end

        def engine
          ClamAV.instance
        end

        class ClamavScanResult < Ddr::Antivirus::ScanResult

          def virus_found
            raw if has_virus?
          end

          def has_virus?
            ![0, 1].include?(raw)
          end

          def error?
            raw == 1
          end

          def status
            return "FOUND #{virus_found}" if has_virus?
            return "ERROR" if error?
            "OK"
          end

          def to_s
            "#{file_path}: #{status} (#{version})"
          end

          def default_version
            # Engine and database versions
            # E.g., ClamAV 0.98.3/19010/Tue May 20 21:46:01 2014
            `sigtool --version`.strip
          end

        end

      end
    end
  end
end
