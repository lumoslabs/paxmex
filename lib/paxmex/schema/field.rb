require 'bigdecimal'
require 'paxmex/schema'

module Paxmex
  class Schema
    class Field
      DATE_PATTERN = /^date\((.+)\)$/
      TIME_PATTERN = /^time\((.+)\)$/

      attr_reader :name, :start, :final, :type

      def initialize(opts = {})
        @name  = opts[:name]
        @start = opts[:start]
        @final = opts[:final]
        @type  = opts[:type] || 'string'
      end

      def parse(raw_value)
        case type
        when 'string' then raw_value.rstrip
        when 'julian' then parse_julian_date(raw_value) rescue nil
        when 'date' then Date.strptime(raw_value, '%m%d%Y') rescue nil
        when 'numeric' then parse_numeric(raw_value)
        when 'decimal' then parse_decimal(raw_value)
        when DATE_PATTERN then parse_date_pattern(raw_value) rescue nil
        when TIME_PATTERN then parse_time_pattern(raw_value) rescue nil
        else fail "Could not parse field type #{type}. Supported types: string, julian, date, numeric, decimal, date(format), time(format)"
        end
      end

      private

      def parse_date_pattern(value)
        Date.strptime(value, DATE_PATTERN.match(type).captures.first)
      end

      def parse_time_pattern(value)
        Time.strptime(value, TIME_PATTERN.match(type).captures.first)
      end

      def parse_numeric(value)
        value.strip!
        return value.to_f if value.include?('.')
        value.to_i
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
  end
end
