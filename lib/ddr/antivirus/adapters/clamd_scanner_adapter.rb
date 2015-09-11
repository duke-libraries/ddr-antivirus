require "open3"
require "fileutils"
require "shellwords"

module Ddr::Antivirus
  #
  # Adapter for clamd client (clamdscan)
  #
  class ClamdScannerAdapter < ScannerAdapter

    SCANNER = "clamdscan".freeze

    def scan(path)
      output, status = clamdscan(path)
      result = ScanResult.new(path, output, version: version, scanned_at: Time.now.utc)
      case status.exitstatus
      when 0
        result
      when 1
        raise VirusFoundError, result.to_s
      when 2
        raise ScannerError, result.to_s
      end
    end

    def clamdscan(path)
      make_readable(path) do
        command(path)
      end
    end

    def version
      out, err, status = Open3.capture3(SCANNER, "-V")
      out.strip
    end

    private

    def command(path)
      safe_path = Shellwords.shellescape(path)
      Open3.capture2e(SCANNER, safe_path)
    end

    def make_readable(path)
      changed = false
      original = File.stat(path).mode # raises Errno::ENOENT
      if !File.world_readable?(path)
        changed = FileUtils.chmod("a+r", path)
        logger.info "File #{path} made world-readable for virus scanning."
      end
      result = yield
      if changed
        FileUtils.chmod(original, path)
        logger.info "Mode reset to original #{original} on file #{path}."
      end
      result
    end

  end

  # Result of a scan with the ClamdScannerAdapter
  # @api private
  class ClamdScanResult < ScanResult

    def virus_found
      if m = /: ([^\s]+) FOUND$/.match(output)
        m[1]
      end
    end

    def ok?
      status.exitstatus == 0
    end

    def has_virus?
      status.exitstatus == 1
    end

    def error?
      status.exitstatus == 2
    end

  end
end
