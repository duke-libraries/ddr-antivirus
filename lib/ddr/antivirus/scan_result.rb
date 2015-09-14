module Ddr::Antivirus
  #
  # The result of a virus scan.
  #
  class ScanResult

    attr_reader :file_path, :output, :scanned_at, :version

    def initialize(file_path, output, scanned_at: nil, version: nil)
      @file_path  = file_path
      @output     = output
      @scanned_at = scanned_at || default_time
      @version    = version    || default_version
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

    # String representation of the result
    # @return [String] the representation.
    def to_s
      "#{output}\n[#{version}]"
    end

  end
end
