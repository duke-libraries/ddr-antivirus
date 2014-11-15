module Ddr
  module Antivirus
    module Adapters
      #
      # The result of a virus scan.
      # 
      class ScanResult
        
        attr_reader :raw, :file_path, :scanned_at, :version
        
        def initialize(raw, file_path, opts={})
          @raw = raw
          @file_path = file_path
          @scanned_at = opts.fetch(:scanned_at, default_time)
          @version = opts.fetch(:version, default_version)
        end

        # Default time of virus scan - i.e., now.
        # @return [Time] the time.
        def default_time
          Time.now.utc
        end

        # Default anti-virus software version information.
        # @return [String] the version.
        def default_version
          "ddr-antivirus #{Ddr::Antivirus::VERSION}"
        end

        # the name of virus found.
        # @return [String] the virus name.
        def virus_found; end

        # Was a virus found? 
        # @return [true, false] whether a virus was found.
        def has_virus?
          !virus_found.nil?
        end

        # Was there an error (reported by the scanner, not necessarily an exception)?
        # @return [true, false] whether there was an error.
        def error?
          false
        end

        # Was the result OK - i.e., not an error and virus not found.
        # @return [true, false] whether the result was OK.
        def ok?
          !(has_virus? || error?)
        end

        # String representation of the result
        # @return [String] the representation.
        def to_s
          "#{raw} (#{version})"
        end

      end
    end
  end
end
