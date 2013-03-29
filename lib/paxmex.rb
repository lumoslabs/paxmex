module Paxmex
  def self.parse_eptrn(file)
    Paxmex::EptrnParser.parse(file)
  end

  def self.parse_epraw(file)
    Paxmex::EprawParser.parse(file)
  end
end
