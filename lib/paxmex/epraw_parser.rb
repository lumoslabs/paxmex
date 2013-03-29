class Paxmex::EprawParser
  attr_accessor :path

  def initialize(file_path)
    @path = file_path
  end
end
