require "logger"

require_relative "antivirus/version"
require_relative "antivirus/scanner"
require_relative "antivirus/adapters"

require "active_support/core_ext/module/attribute_accessors"

module Ddr
  module Antivirus

    class VirusFoundError < ::StandardError; end

    def self.configure
      yield self
    end

    #
    # Custom logger
    #
    # Defaults to Rails logger if Rails is loaded; otherwise logs to STDERR.
    #
    mattr_accessor :logger do
      if defined?(Rails) && Rails.logger
        Rails.logger
      else 
        Logger.new(STDERR)    
      end
    end

    #
    # Scanner adapter
    #
    # Defaults to:
    # - :clamav adapter if the 'clamav' gem is installed; 
    # - :clamd adapter if the 'clamdscan' executable is available;
    # - otherwise, the :null adapter.
    #
    mattr_accessor :scanner_adapter do
      begin
        require "clamav"
        :clamav
      rescue LoadError
        if system "which -s clamdscan"
          :clamd
        else
          :null
        end
      end
    end

  end
end
