require 'bigdecimal'
require 'paxmex/schema'

class Paxmex::Schema::Field
  attr_reader :name, :start, :final, :type

  def initialize(opts = {})
    @name  = opts[:name]
    @start = opts[:start]
    @final = opts[:final]
    @type  = opts[:type] || 'string'
  end

  def parse(raw_value)
    case type
    when 'julian' then parse_julian_date(raw_value)
    when 'date' then Date.strptime(raw_value, '%m%d%Y')
    when 'numeric' then raw_value.strip.to_i
    when 'decimal' then parse_decimal(raw_value)
    else raw_value.strip
    end
  end

  def parse_decimal(value)
    is_credit = !!(value =~ /[JKLMNOPQR}]/)
    value = value.gsub(/[ABCDEFGHIJKLMNOPQR{}]/,
      'A' => 1, 'B' => 2, 'C' => 3,
      'D' => 4, 'E' => 5, 'F' => 6,
      'G' => 7, 'H' => 8, 'I' => 9,
      'J' => 1, 'K' => 2, 'L' => 3,
      'M' => 4, 'N' => 5, 'O' => 6,
      'P' => 7, 'Q' => 8, 'R' => 9,
      '{' => 0, '}' => 0)

    BigDecimal.new(value.to_i * (is_credit ? -1 : 1) / 100.0, 7)
  end

  def parse_julian_date(date_string)
    Date.ordinal(date_string[0..3].to_i, date_string[4..6].to_i)
  end
end
