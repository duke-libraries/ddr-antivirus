# Ddr::Antivirus

Pluggable antivirus service for Ruby applications.

[![Gem Version](https://badge.fury.io/rb/ddr-antivirus.svg)](http://badge.fury.io/rb/ddr-antivirus)
[![Build Status](https://travis-ci.org/duke-libraries/ddr-antivirus.svg?branch=develop)](https://travis-ci.org/duke-libraries/ddr-antivirus)

## Installation

Add this line to your application's Gemfile:

    gem 'ddr-antivirus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ddr-antivirus

### Scanning ###

```ruby
require "ddr-antivirus"

result = Ddr::Antivirus.scan(path)

Ddr::Antivirus.scanner do |scanner|
  result = scanner.scan(path)
end
```

### Exceptions

All exceptions under the `Ddr::Antivirus` namespace.

`Error` - Parent exception class.

`VirusFoundError` - A virus was found. The message includes the original output from the scanner.

`ScannerError` - The scanner encountered an error (e.g., error exit status).

### Example

```
> require 'ddr/antivirus'
 => true
 
> Ddr::Antivirus.scanner_adapter = :clamd
 => :clamd

> result = Ddr::Antivirus.scan "/path/to/image.jpg"
 => #<Ddr::Antivirus::ScanResult:0x007f98f8b95670 @file_path="/path/to/image.jpg", @output="/path/to/image.jpg: OK\n\n----------- SCAN SUMMARY -----------\nInfected files: 0\nTime: 0.001 sec (0 m 0 s)\n", @scanned_at=2015-09-11 20:41:17 UTC, @version="ClamAV 0.98.7/20903/Fri Sep 11 08:42:07 2015">

> result.version
 => "ClamAV 0.98.7/20903/Fri Sep 11 08:42:07 2015"

> result.scanned_at
 => 2015-09-11 20:41:17 UTC

> result.output
 => "/path/to/image.jpg: OK\n\n----------- SCAN SUMMARY -----------\nInfected files: 0\nTime: 0.001 sec (0 m 0 s)\n"

> puts result.to_s
/path/to/image.jpg: OK

----------- SCAN SUMMARY -----------
Infected files: 0
Time: 0.001 sec (0 m 0 s)

[ClamAV 0.98.7/20903/Fri Sep 11 08:42:07 2015]
```

### Logging

In a Rails application, `Ddr::Antivirus` will log messages to the Rails logger by default. The fallback logger writes to STDERR.  You may also explicitly set `Ddr::Antivirus.logger` to any object that supports the Ruby logger API:

```ruby
require "logger"
Ddr::Antivirus.logger = Logger.new("/path/to/custom.log")
```

### The NullScannerAdapter

In order to avoid the overhead of ClamAV in test and/or development environments, the package provides a no-op adapter:

```
>> Ddr::Antivirus.scanner_adapter = :null
=> :null
>> Ddr::Antivirus::Scanner.scan("/path/to/blue-devil.png")
=> #<Ddr::Antivirus::NullScanResult:0x007f9e2ba1af38 @output="/path/to/blue-devil.png: NOT SCANNED - using :null scanner adapter.", @file_path="/path/to/blue-devil.png", @scanned_at=2014-11-07 20:58:17 UTC, @version="ddr-antivirus 1.2.0">
```

### Test Mode

To easily configure `Ddr::Antivirus` to use the `NullScannerAdapter` and log to the null device, turn on test mode:

```ruby
Ddr::Antivirus.test_mode!
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ddr-antivirus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
