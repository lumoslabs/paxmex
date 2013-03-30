class Paxmex::EprawParser < Paxmex::Parser
  def self.schema_hash
    @schema_hash ||= YAML::load(File.open('config/eptraw.yml'))
  end
end
