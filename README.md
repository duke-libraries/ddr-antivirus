# Ddr::Antivirus

Antivirus scanner for Ruby applications.

## Installation

Add this line to your application's Gemfile:

    gem 'ddr-antivirus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ddr-antivirus

## ClamAV Dependencies

For system dependencies, see https://github.com/eagleas/clamav.

Ddr::Antivirus intentionally does *not* include `clamav` as a runtime dependency.  Rather you should add to you application's Gemfile:

    gem 'clamav'

Ddr::Antivirus will automatically use an adapter class for ClamAV if the Ruby gem is installed.

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

### Results

Class: `Ddr::Antivirus::ScanResult`

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

# String representation
>> puts result.to_s
Virus scan: OK - /path/to/blue-devil.png (ClamAV 0.98.3/19559/Thu Oct 30 06:39:46 2014)
```

### The NullScannerAdapter

In order to avoid the overhead of ClamAV in test and/or development environments, the package provides a no-op adapter that logs a message and returns a normal scan result (instance of Ddr::Antivirus::ScanResult).

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
