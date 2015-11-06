module Ddr::Antivirus

  class Error < ::StandardError; end

  class MaxFileSizeExceeded < Error; end

  class ResultError < Error
    attr_reader :result
    def initialize(result)
      super(result.to_s)
      @result = result
    end
  end

  class VirusFoundError < ResultError; end

  class ScannerError < ResultError; end

end
