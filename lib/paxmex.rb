require 'paxmex/parser'

module Paxmex
  class << self
    def parse_cbnot(*args)
      parse('cbnot', *args)
    end

    def parse_epa(*args)
      parse('epa', *args)
    end

    def parse_epraw(*args)
      parse('epraw', *args)
    end

    def parse_eptrn(*args)
      parse('eptrn', *args)
    end

    private

    def parse(schema, *args)
      Parser.new(args.shift, schema).parse(*args)
    end
  end
end
