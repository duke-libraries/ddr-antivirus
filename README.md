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

Ddr::Antivirus will use an adapter class for ClamAV if the Ruby gem is installed.

## Usage

### Scanning ###

```ruby
require "ddr-antivirus"

result = Ddr::Antivirus::Scanner.scan(path)

Ddr::Antivirus::Scanner.new do |scanner|
  result = scanner.scan(path)
end
```

### Results

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

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ddr-antivirus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
