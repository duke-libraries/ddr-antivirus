require "fileutils"
require "shellwords"

module Ddr::Antivirus
  #
  # Adapter for clamd client (clamdscan)
  #
  class ClamdScannerAdapter < ScannerAdapter

    SCANNER = "clamdscan".freeze
    CONFIG = "clamconf".freeze

    MAX_FILE_SIZE_RE = Regexp.new('^MaxFileSize = "(\d+)"')

    def scan(path)
      output, exitcode = clamdscan(path)
      result = ScanResult.new(path, output, version: version, scanned_at: Time.now.utc)
      case exitcode
      when 0
        result
      when 1
        raise VirusFoundError.new(result)
      when 2
        raise ScannerError.new(result)
      end
    end

    def clamdscan(path)
      check_file_size(path) if max_file_size
      output = make_readable(path) do
        command "--fdpass", safe_path(path)
      end
      [ output, $?.exitstatus ]
    end

    def version
      @version ||= command("-V").strip
    end

    def config
      # If client and server are on separate hosts
      # attempt to read config may raise an exception.
      @config ||= `#{CONFIG}` rescue nil
    end

    def max_file_size
      if m = MAX_FILE_SIZE_RE.match(config)
        m[1].to_i
      end
    end

    private

    def check_file_size(path)
      if (file_size = File.size(path)) > max_file_size
        raise MaxFileSizeExceeded, "Unable to scan file \"#{path}\" because size (#{file_size})" \
                                   " exceeds clamconf MaxFileSize (#{max_file_size})."
      end
    end

    def command(*args)
      cmd = args.dup.unshift(SCANNER).join(" ")
      `#{cmd}`
    end

    def make_readable(path)
      changed = false
      original = File.stat(path).mode # raises Errno::ENOENT
      if !File.world_readable?(path)
        changed = FileUtils.chmod("a+r", path)
        logger.debug "#{self.class} - File \"#{path}\" made world-readable."
      end
      result = yield
      if changed
        FileUtils.chmod(original, path)
        logger.debug "#{self.class} - Mode on file \"#{path}\" reset to original: #{original}."
      end
      result
    end

    def safe_path(path)
      Shellwords.shellescape(path)
    end

  end
end
