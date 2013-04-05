class Paxmex::Schema
  require 'paxmex/schema/section'

  def initialize(schema_hash)
    @schema_hash = schema_hash
  end

  def sections
    @sections ||= @schema_hash.map { |k, v| Section.new(k, v) }
  end

  def to_h
    @schema_hash
  end
end
