# Paxmex

This gem parses your Amex data files into human readable data.

## Installation

### From RubyGems.org

```sh
% gem install paxmex
```

## Available Methods

* parse_eptrn(file_path)
* parse_epraw(file_path)

Both methods return a readable hash in the following format:

```ruby
{
  "DATA_FILE_TRAILER_RECORD" => {
    "DF_TRL_RECORD_TYPE" => "DFTRL",
    "DF_TRL_DATE" => "03082013",
    "DF_TRL_TIME" => "0435",
    "DF_TRL_FILE_ID" => "000000",
    "DF_TRL_FILE_NAME" => "LUMOS LABS INC      ",
    "DF_TRL_RECIPIENT_KEY" => "00000000002754170029          0000000000",
    "DF_TRL_RECORD_COUNT" => "0000004"
  },
  "DATA_FILE_HEADER_RECORD" => {
    "DF_HDR_RECORD_TYPE" => "DFHDR",
    "DF_HDR_DATE" => "03082013",
    "DF_HDR_TIME" => "0435",
    "DF_HDR_FILE_ID" => "000000",
    "DF_HDR_FILE_NAME" => "LUMOS LABS INC"
  },
  ...
}
```

## Example

```ruby
require 'paxmex'
Paxmex.parse_eptrn('/path/to/amex/eptrn/raw/file')
Paxmex.parse_epraw('/path/to/amex/epraw/raw/file')
```

Output and key-value pairs vary depending on whether you choose to parse an EPTRN or EPRAW file.

## Contributing

Fork and submit a pull request and make sure you add a test for any feature you add.

## License

LICENSE: (The MIT License)
