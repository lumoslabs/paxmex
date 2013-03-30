module Paxmex
  require 'paxmex/parser'
  require 'paxmex/eptrn_parser'
  require 'paxmex/epraw_parser'

  def self.parse_eptrn(file)
    Paxmex::EptrnParser.new(file).parse
  end

  def self.parse_epraw(file)
    Paxmex::EptrawParser.new(file).parse
  end
end
