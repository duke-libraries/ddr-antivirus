module Ddr
  module Antivirus
    module Adapters
      #
      # ClamdScannerAdapter uses an external ClamAV daemon (clamd)
      # 
      # See https://github.com/soundarapandian/clamd for configuration method and options.
      #
      class ClamdScannerAdapter < ScannerAdapter

        def scan(path)
          raw = clamdscan(path)
          ClamdScanResult.new(raw, path)
        end

        def clamdscan(path)
          `clamdscan --no-summary #{path}`.strip
        end

        class ClamdScanResult < Ddr::Antivirus::ScanResult
          
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
end
