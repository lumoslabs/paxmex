require 'yaml'
require 'paxmex/schema'

class Paxmex::Parser
  attr_reader :schema, :path

  def initialize(data_file, schema)
    @path = data_file

    if File.file?(schema)
      schema_file = schema
    else
      schema_file = File.expand_path("../../config/#{schema}.yml", File.dirname(__FILE__))
    end

    @schema = Paxmex::Schema.new(YAML.load_file(schema_file))
  end

  def raw
    @raw ||= File.read(@path).chomp
  end

  def parse(opts = {})
    return @parsed if @parsed

    content = raw.split("\n")

    # Parse the trailing section first so that we don't need
    # to consider it when parsing recurring sections
    trailer_section = schema.sections.detect(&:trailer?)
    trailer_content = [content.slice!(-1)]
    @parsed = parse_section(trailer_section, trailer_content, raw: opts[:raw_values])

    schema.sections.reject(&:trailer?).each.with_object(@parsed) do |s, o|
      section_content = s.recurring? ? content : [content.slice!(0)]
      o.update(parse_section(s, section_content, raw: opts[:raw_values]))
    end
  end

  private

  def parse_section(section, content, opts = {})
    result = {}
    abstract_section = section if section.abstract?

    content.each do |section_content|
      if abstract_section
        start, final = abstract_section.type_field
        section_type = section_content[start..final]
        section = abstract_section.section_for_type(section_type)
      end

      result[section.key] ||= [] if section.recurring?

      p = {}
      section.fields.each do |field|
        raw_value = section_content[field.start..field.final]
        p[field.name] = opts[:raw] ? raw_value : field.parse(raw_value)
      end

      if section.recurring?
        result[section.key] << p
      else
        result[section.key] = p
      end
    end

    result
  end
end
