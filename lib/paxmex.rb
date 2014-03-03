module Paxmex
  require 'paxmex/parser'

  def self.parse_eptrn(file, opts = {})
    Parser.new(file, schema: 'eptrn').parse(opts)
  end

  def self.parse_epraw(file, opts = {})
    Parser.new(file, schema: 'epraw').parse(opts)
  end
end
