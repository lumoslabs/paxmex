class Paxmex::ParsedSection < Hash
  attr_reader :section

  def initialize(section, raw_result = {}, &blk)
    @section = section
    @children = {}

    super(&blk) if block_given?
    raw_result.each { |k, v| self[k] = v }
  end

  def key
    section.key
  end

  def children
    self[:children]
  end

  def add_child(key, child)
    self[:children] ||= {}
    self[:children][key] ||= []
    self[:children][key] << child
  end

end
