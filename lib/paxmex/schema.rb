class Paxmex::Schema
  require 'paxmex/schema/section'

  def initialize(schema_hash)
    @schema_hash = schema_hash
    @parents = []
  end

  def sections
    @sections ||= @schema_hash.map { |k, v| build_section(k,v) }
  end

  def to_h
    @schema_hash
  end

  def parent_section?(key)
    sections.any? do |s|
      if s.abstract?
        s.sections_for_types.any? { |ss| ss.parent_key == key }
      else
        s.parent_key == key
      end
    end
  end

  private

  def build_section(key, data)
    section = Section.new(key, data)
    mark_abstract if section.abstract?
    add_parent(section) if section.child?

    section
  end

  def mark_abstract
    fail 'Cannot have more than one abstract section' if @have_abstract
    @have_abstract = true
  end

  def add_parent(section)
    fail 'Recursive parent definition' if @parents.include?(section.key)
    @parents << parent
  end

end
