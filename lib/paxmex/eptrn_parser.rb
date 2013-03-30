class Paxmex::EptrnParser < Paxmex::Parser
  def self.schema_hash
    @schema_hash ||= YAML::load(File.open('config/eptrn.yml'))
  end
end
