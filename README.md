# Ddr::Antivirus

Pluggable antivirus service for Ruby applications.

[![Gem Version](https://badge.fury.io/rb/ddr-antivirus.svg)](http://badge.fury.io/rb/ddr-antivirus)
[![Build Status](https://travis-ci.org/duke-libraries/ddr-antivirus.svg?branch=develop)](https://travis-ci.org/duke-libraries/ddr-antivirus)
[![Coverage Status](https://coveralls.io/repos/duke-libraries/ddr-antivirus/badge.png?branch=develop)](https://coveralls.io/r/duke-libraries/ddr-antivirus?branch=develop)
[![Code Climate](https://codeclimate.com/github/duke-libraries/ddr-antivirus/badges/gpa.svg)](https://codeclimate.com/github/duke-libraries/ddr-antivirus)

## Installation

Add this line to your application's Gemfile:

    gem 'ddr-antivirus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ddr-antivirus

## How It Works

Ddr::Antivirus does *not* provide a virus scanning engine as a runtime dependency. Instead, it will select a scanner adapter class for the software it finds in your environment following this procedure:

- If the [clamav](https://github.com/eagleas/clamav) gem is available, it will select the `ClamavScannerAdapter`.
- If the ClamAV Daemon client `clamdscan` is on the user's path, it will select the `ClamdScannerAdapter`.  Ddr::Antivirus *does not* manage clamd -- i.e., checking its status, starting or reloading the database.  These tasks must be managed externally.
- Otherwise, it will select the [`NullScannerAdapter`](#the-nullscanneradapter).

The auto-selection process may be overridden by configuration:

```ruby
Ddr::Antivirus.configure do |config|
  config.scanner_adapter = :clamd # or :clamav, or :null
end
```

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

The scanner raises a `Ddr::Antivirus::VirusFoundError` exception if a virus is found.

### Results

Class: `Ddr::Antivirus::Adapters::ScanResult`

A scanner adapter may subclass the base class to parse the raw result properly.

```ruby
>> require "ddr-antivirus"
=> true

>> result = Ddr::Antivirus::Scanner.scan("/path/to/blue-devil.png")
=> #<Ddr::Antivirus::Adapters::ClamavScanResult:0x007f98fb169cc0 ...

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
>> result.to_s
=> "/path/to/blue-devil.png: OK (ClamAV 0.98.3/19595/Thu Nov  6 11:32:29 2014)"
```

### Logging

In a Rails application, `Ddr::Antivirus` will log messages to the Rails logger by default. The fallback logger writes to STDERR.  You may also explicitly set `Ddr::Antivirus.logger` to any object that supports the Ruby logger API:

```ruby
require "logger"
Ddr::Antivirus.logger = Logger.new("/path/to/custom.log")
```

### The NullScannerAdapter

In order to avoid the overhead of ClamAV in test and/or development environments, the package provides a no-op adapter:

```ruby
>> Ddr::Antivirus.scanner_adapter = :null
=> :null
>> Ddr::Antivirus::Scanner.scan("/path/to/blue-devil.png")
I, [2014-11-07T15:58:17.706866 #82651]  INFO -- : /path/to/blue-devil.png: NOT SCANNED - using :null scanner adapter. (ddr-antivirus 1.2.0)
=> #<Ddr::Antivirus::Adapters::NullScanResult:0x007f9e2ba1af38 @raw="/path/to/blue-devil.png: NOT SCANNED - using :null scanner adapter.", @file_path="/path/to/blue-devil.png", @scanned_at=2014-11-07 20:58:17 UTC, @version="ddr-antivirus 1.2.0">
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ddr-antivirus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
