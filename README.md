# Paxmex

This gem parses your Amex data files into human readable data.

## Installation

### From RubyGems.org

```sh
% gem install paxmex
```

## Available Methods

* parse_eptrn(file_path)
* parse_eptrn(file_path)

## Example

```ruby
require 'paxmex'
Paxmex.parse_eptrn('/path/to/amex/eptrn/raw/file')
Paxmex.parse_epraw('/path/to/amex/epraw/raw/file')
```

## Contributing

Fork and submit a pull request and make sure you add a test for any feature you add.

## License

LICENSE: (The MIT License)
