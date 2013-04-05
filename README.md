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
    "DF_TRL_DATE" => #<Date: 2013-04-05>,
    "DF_TRL_TIME" => "0435",
    "DF_TRL_FILE_ID" => 0,
    "DF_TRL_FILE_NAME" => "LUMOS LABS INC",
    "DF_TRL_RECIPIENT_KEY" => "00000000002754170029          0000000000",
    "DF_TRL_RECORD_COUNT" => 4
  },
  "DATA_FILE_HEADER_RECORD" => {
    "DF_HDR_RECORD_TYPE" => "DFHDR",
    "DF_HDR_DATE" => #<Date: 2013-04-05>,
    "DF_HDR_TIME" => "0435",
    "DF_HDR_FILE_ID" => 0,
    "DF_HDR_FILE_NAME" => "LUMOS LABS INC"
  },
  ...
}
```

Values are parsed from their representation into a corresponding native Ruby type:

* Alphanumeric values become strings (with whitespace stripped)
* Numeric values become Fixnums
* Julian strings become Date objects
* Date strings become Date objects
* Alphanumerically represented decimals become BigDecimal objects (e.g: ```'0000000011A' -> BigDecimal.new(1.11, 7)```)

If you'd like the raw values to be returned instead, you can set the ```raw_values``` option to true, e.g.:

```ruby
Paxmex.parse_eptrn(path_to_file, raw_values: true)
Paxmex.parse_epraw(path_to_file, raw_values: true)
```


## Example

```ruby
require 'paxmex'
Paxmex.parse_eptrn('/path/to/amex/eptrn/raw/file')
Paxmex.parse_epraw('/path/to/amex/epraw/raw/file')
```

The input files for either methods is a data report file provided by American Express. These files are in either EPRAW or EPTRN format so use the relevant method to parse them. We have provided dummy EPRAW and EPTRN files in `spec/support`. Output and key-value pairs vary depending on whether you choose to parse an EPTRN or EPRAW file.

## Contributing

Fork and submit a pull request and make sure you add a test for any feature you add.

## License

LICENSE: (The MIT License)
