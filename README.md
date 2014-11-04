# Ddr::Antivirus

[![Gem Version](https://badge.fury.io/rb/ddr-antivirus.svg)](http://badge.fury.io/rb/ddr-antivirus)
[![Build Status](https://travis-ci.org/duke-libraries/ddr-antivirus.svg?branch=master)](https://travis-ci.org/duke-libraries/ddr-antivirus)

Antivirus scanner for Ruby applications.

## Installation

Add this line to your application's Gemfile:

    gem 'ddr-antivirus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ddr-antivirus

## How It Works

Ddr::Antivirus does *not* provide a virus scanning engine as a runtime dependency. Instead, it will select a scanner adapter class for the software it finds in your environment following this procedure:

- If the [clamav](https://github.com/eagleas/clamav) gem is available, it will select the ClamavScannerAdapter.
- If the ClamAV Daemon client `clamdscan` is on the user's path, it will select the ClamdScannerAdapter.
- Otherwise, it will select the [NullScannerAdapter](#the-nullscanneradapter), which does not perform virus scans and is intended for testing and development.

## Usage

### Scanning ###

Class: `Ddr::Antivirus::Scanner`

```ruby
require "ddr-antivirus"

# Using the class method .scan
result = Ddr::Antivirus::Scanner.scan(path)

# Using the instance method #scan with a block
Ddr::Antivirus::Scanner.new do |scanner|
  result = scanner.scan(path)
end
```

The scanner raises an exception (Ddr::Antivirus::VirusFoundError) if a virus is found.

### Results

Class: `Ddr::Antivirus::ScanResult`

A scanner adapter may subclass the base class to parse the raw result properly.

```ruby
>> require "ddr-antivirus"
=> true

>> result = Ddr::Antivirus::Scanner.scan("/path/to/blue-devil.png")
=> #<Ddr::Antivirus::Adapters::ClamavScannerAdapter::ClamavScanResult:0x007f98fb169cc0 ...

# Was there a virus?
>> result.has_virus?
=> false

# Was there an error?
>> result.error?
=> false 

# Success? (no virus or error)
>> result.ok?
=> true

# What did the scanner adapter return?
>> result.raw
=> 0 # ClamAV example

# String representation (example)
>> puts result.to_s
=> /path/to/blue-devil.png: OK (ClamAV 0.98.3/19559/Thu Oct 30 06:39:46 2014)
```

### The NullScannerAdapter

In order to avoid the overhead of ClamAV in test and/or development environments, the package provides a no-op adapter that logs a message and returns a scan result object (instance of Ddr::Antivirus::ScanResult).

```ruby
>> Ddr::Antivirus.scanner_adapter = :null
=> :null
>> Ddr::Antivirus::Scanner.scan("/path/to/blue-devil.png")
W, [2014-10-30T16:21:24.349542 #76244]  WARN -- : File not scanned -- using :null scanner adapter.
I, [2014-10-30T16:21:24.350582 #76244]  INFO -- : #<Ddr::Antivirus::ScanResult:0x007ff6c98d0500 @raw="File not scanned -- using :null scanner adapter.", @file_path="/path/to/blue-devil.png", @scanned_at=2014-10-30 20:21:24 UTC, @version="ddr-antivirus 1.0.0.rc1">
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ddr-antivirus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
