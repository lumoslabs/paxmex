module Paxmex
  def self.parse_eptrn(file)
    Paxmex::EptrnFile.parse(file)
  end

  def self.parse_epraw(file)
    Paxmex::EprawFile.parse(file)
  end
end
