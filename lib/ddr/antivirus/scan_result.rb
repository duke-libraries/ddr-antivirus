module Ddr
  module Antivirus
    #
    # Default scan result implementation
    # 
    class ScanResult
      
      attr_reader :raw, :file_path, :scanned_at, :version
      
      def initialize(raw, file_path, opts={})
        @raw = raw
        @file_path = file_path
        @scanned_at = opts.fetch(:scanned_at, default_time)
        @version = opts.fetch(:version, default_version)
      end

      def default_time
        Time.now.utc
      end

      def default_version
        "ddr-antivirus #{Ddr::Antivirus::VERSION}"
      end

      # Subclasses may override to provide description of virus found.
      def virus_found; end

      # Subclasses should override
      def has_virus?
        !virus_found.nil?
      end

      # Subclasses may override to indicate an error condition (not necessarily an exception).
      def error?
        false
      end

      def ok?
        !(has_virus? || error?)
      end

      # Subclasses may override
      def to_s
        "#{raw} (#{version})"
      end

    end
  end
end

