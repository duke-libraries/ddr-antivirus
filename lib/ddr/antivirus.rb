require "ddr/antivirus/version"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/dependencies/autoload"
require "logger"

module Ddr
  module Antivirus
    extend ActiveSupport::Autoload

    class VirusFoundError < ::StandardError; end

    def self.clamav_installed?
      begin
        require 'clamav'
      rescue LoadError
        false
      else
        true
      end
    end

    def self.configure
      yield self
    end

    autoload :Scanner
    autoload :ScanResult
    autoload :Adapters

    # Custom logger
    # Defaults to Rails logger if Rails is loaded; otherwise logs to STDERR.
    mattr_accessor :logger do
      defined?(Rails) && Rails.logger ? Rails.logger : Logger.new(STDERR)    
    end

    # Scanner adapter
    # Defaults to :clamav adapter if ClamAV is installed; otherwise uses the :null adapter
    mattr_accessor :scanner_adapter do
      clamav_installed? ? :clamav : :null
    end

  end
end
