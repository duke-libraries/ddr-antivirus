require "delegate"

module Ddr::Antivirus
  class Scanner < SimpleDelegator
      
    def self.scan(path)
      new.scan(path)
    end

    def initialize
      super Ddr::Antivirus.get_adapter.new
    end

  end
end

