require 'yaml'
require 'schema'

class Paxmex::Parser
  def initialize(path)
    @path = path
    @schema = Paxmex::Schema.new(self.class.schema_hash)
  end

  def raw
    @raw ||= File.read(@path).chomp
  end

  def parse
    return @parsed if @parsed

    content = raw.dup

    trailer_section = schema.sections.detect(&:trailer?)
    trailer_content = content.slice!(content.length - trailer_section.length..content.length)
    @parsed = parse_section(content: trailer_content, section: trailer_section)

    (schema.sections - [trailer_section]).each do |section|
      section_content = section.recurring? ? content : content.slice!(0..section.length)
      parsed_section = parse_section(content: section_content, section: section)
      @parsed.merge!(parsed_section)
    end

    @parsed
  end

  private

  attr_reader :schema

  def parse_section(opts = {})
    raise 'Content must be provided' unless content = opts[:content]
    raise 'Section must be provided' unless section = opts[:section]

    if section.abstract?
      start, final = section.type_field
      section_type = content[start..final]
      section = section.section_for_type(section_type)
    end

    result = {section.key => {}}
    section.fields.each do |field_name, positions|
      start, final = positions
      result[section.key][field_name] = content[start..final]
    end
    result
  end
end
