class Paxmex::EptrnParser
  attr_accessor :path

  def initialize(file_path)
    @path = file_path
  end

  def parse
    path_yml = "../config/eptrn.yml"
  end
end
