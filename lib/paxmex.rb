module Paxmex
  require 'paxmex/parser'

  def self.parse_eptrn(file)
    Parser.new(file, schema: 'eptrn').parse
  end

  def self.parse_epraw(file)
    Parser.new(file, schema: 'epraw').parse
  end
end
