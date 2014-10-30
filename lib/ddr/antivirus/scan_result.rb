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
      # Should return nil if no virus found.
      def virus_found; end

      def has_virus?
        !virus_found.nil?
      end

      def status
        return status_found if has_virus?
        return status_error if error?
        status_ok
      end

      def ok?
        !(has_virus? || error?)
      end

      # Subclasses may implement to indicate an error condition (not necessarily an exception).
      def error?
        false
      end

      def status_error
        "ERROR"
      end

      def status_ok
        "OK"
      end

      def status_found
        "FOUND #{virus_found}"
      end

      def to_s
        "Virus scan: #{status} - #{file_path} (#{version})"
      end

    end
  end
end

