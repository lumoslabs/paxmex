require 'paxmex/parser'

module Paxmex
  class SchemaProxy
    attr_reader :schema_name

    def initialize(schema_name)
      @schema_name = schema_name
    end

    def parse(data, opts = {})
      Parser.new(data, schema_name).parse(opts)
    end

    def load_file(file, opts = {})
      parse(File.read(file), opts)
    end
  end

  class << self
    def cbnot
      @cbnot ||= SchemaProxy.new('cbnot')
    end

    def epa
      @epa ||= SchemaProxy.new('epa')
    end

    def epraw
      @epraw ||= SchemaProxy.new('epraw')
    end

    def eptrn
      @eptrn ||= SchemaProxy.new('eptrn')
    end
  end
end
