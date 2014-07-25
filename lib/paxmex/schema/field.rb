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
    date_pattern = /^date\((.+)\)$/
    time_pattern = /^time\((.+)\)$/

    case type
    when 'julian' then parse_julian_date(raw_value)
    when 'date' then Date.strptime(raw_value, '%m%d%Y')
    when 'numeric' then raw_value.strip.to_i
    when 'decimal' then parse_decimal(raw_value)
    when date_pattern then Date.strptime(raw_value, date_pattern.match(type).captures.first)
    when time_pattern then Time.strptime(raw_value, time_pattern.match(type).captures.first)
    else raw_value.rstrip
    end
  end

  def parse_decimal(value)
    # fields _may_ end with a letter
    unless value.match(/^[0-9]*[0-9A-R{}]$/)
      fail "Unexpected value '#{value}' for field '#{name}'"
    end

    is_credit = !!(value =~ /[JKLMNOPQR}]/)
    value = value.gsub(/[ABCDEFGHIJKLMNOPQR{}]/,
      'A'=>1, 'B'=>2, 'C'=>3, 'D'=>4, 'E'=>5, 'F'=>6, 'G'=>7, 'H'=>8, 'I'=>9,
      'J'=>1, 'K'=>2, 'L'=>3, 'M'=>4, 'N'=>5, 'O'=>6, 'P'=>7, 'Q'=>8, 'R'=>9,
      '{'=>0, '}'=>0)

    parsed_value = value.to_i * (is_credit ? -1 : 1) / 100.0
    BigDecimal.new(parsed_value.to_s, 7)
  end

  def parse_julian_date(date_string)
    Date.ordinal(date_string[0..3].to_i, date_string[4..6].to_i)
  end
end
