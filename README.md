[![Build Status](https://travis-ci.org/lumoslabs/paxmex.png)](https://travis-ci.org/lumoslabs/paxmex)

# Paxmex

This gem parses your Amex data files into human readable data.

## Installation

### From RubyGems.org

```sh
% gem install paxmex
```

## Available Formats

* eptrn
* epraw
* cbnot
* epa

## Usage

Each report format has a corresponding method on the `Paxmex` module. Call `parse` or `load_file` on the return value to either parse data in memory or from a file:

```ruby
Paxmex.eptrn.parse("...")
Paxmex.eptrn.load_file('/path/to/file.cbnot')
```

The first three report formats (i.e. eptrn, epraw, and cbnot) return a hash in the following format:

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

The last format (epa) returns nearly the same thing, but contains nested records as indicated by the epa schema definition:

```ruby
{
  "TRAILER_RECORD" => {
    ...
  },
  "HEADER_RECORD" => {
    ...
  },
  "PAYMENT_SUMMARY" => [
    {
      ...
      "SETTLEMENT_SE_ACCOUNT_NUMBER" => "1234567891",
      "SETTLEMENT_ACCOUNT_NAME_CODE" => "002",
      :children => {
        "SUMMARY_OF_CHARGE" => [
          {
            ...
            "SOC_DATE" => #<Date: 2014-18-07>,
            "DISCOUNT_AMOUNT" => #<BigDecimal: '-0.385E1'>,
            :children => {
              "RECORD_OF_CHARGE" => [
                {
                  ...
                  "CHARGE_AMOUNT" => #<BigDecimal: '0.135E3'>,
                  "CHARGE_DATE" => #<Date: 2014-17-07>,
                  "6-DIGIT_CHARGE_AUTHORISATION_CODE" => "123456"
                },
                ...
              ]
              ...
```

Values are parsed from their representation into a corresponding native Ruby type:

* Alphanumeric values become strings (with whitespace stripped)
* Numeric values become Fixnums
* Julian strings become Date objects
* Date strings become Date objects
* Time strings become Time objects
* Alphanumerically represented decimals become BigDecimal objects (e.g: ```'0000000011A' -> BigDecimal.new(1.11, 7)```)

If you'd like the raw values to be returned instead, you can set the ```raw_values``` option to true, e.g.:

```ruby
Paxmex.eptrn.parse(path_to_file, raw_values: true)
Paxmex.epraw.parse(path_to_file, raw_values: true)
Paxmex.cbnot.parse(path_to_file, raw_values: true)
Paxmex.epa.parse(path_to_file, raw_values: true)
```

## User-defined schema

If you need to parse a different format (i.e. not EPRAW, EPTRN, CBNOT, or EPA), write your own schema definition and use it like this:

```ruby
parser = Parser.new(path_to_raw_file, path_to_schema_file)
result = parser.parse
```

## Example

```ruby
require 'paxmex'

# Use default schema definitions
Paxmex.eptrn.parse('/path/to/amex/eptrn/raw/file')
Paxmex.epraw.parse('/path/to/amex/epraw/raw/file')
Paxmex.cbnot.parse('/path/to/amex/cbnot/raw/file')
Paxmex.epa.parse('/path/to/amex/epa/raw/file')

# Use your own schema definition
parser = Parser.new('/path/to/raw/file', '/path/to/your/schema.yml')
result = parser.parse
```

The raw input files for either methods are data report files provided by American Express. These files are in either EPRAW, EPTRN, CBNOT, or EPA format so use the relevant method to parse them. We have provided dummy EPRAW, EPTRN, CBNOT, and EPA files in `spec/support`. Output and key-value pairs vary depending on whether you choose to parse an EPTRN, EPRAW, CBNOT, or EPA file.

If you need to parse a file in another format, you can write your own YAML schema for this purpose. We would be happy if you help us improving this project by sharing your schemas.

## Contributing

Fork and submit a pull request and make sure you add a test for any feature you add.

## License

LICENSE: (The MIT License)
