require 'yaml'
require 'paxmex/schema'
require 'paxmex/parsed_section'

class Paxmex::Parser
  SCHEMATA = %w(epraw eptrn epa cbnot).reduce({}) do |h, fn|
    file = File.expand_path("../../config/#{fn}.yml", File.dirname(__FILE__))
    h.merge(fn => Paxmex::Schema.new(YAML.load(File.open(file))))
  end

  attr_reader :schema, :path

  def initialize(path, schema)
    @path = path
    @parent_chain = []

    if File.file?(schema)
      @schema = Paxmex::Schema.new(YAML.load_file(schema))
    else
      @schema = SCHEMATA.fetch(schema)
    end
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

    schema.sections.reject(&:trailer?).each_with_object(@parsed) do |s, o|
      break o if content.size == 0
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

      p = Paxmex::ParsedSection.new(section)
      section.fields.each do |field|
        raw_value = section_content[field.start..field.final]
        p[field.name] = opts[:raw] ? raw_value : field.parse(raw_value)
      end

      if section.child?
        trim_parent_chain(section.parent_key)
        add_child_result(@parent_chain.last, section, p)
      else
        trim_parent_chain
        add_root_result(result, section, p)
      end

      if @schema.parent_section?(section.key)
        @parent_chain << p
      end
    end

    result
  end

  # Search right-to-left and compare each parent with the section's parent:
  # - If the match fails, remove parent from the chain and try the next one
  # - If the match succeeds, stop iterating
  #
  # This makes sure cases like this are handled:
  #   + parent1           # set chain to []
  #   ++ child1           # set chain to ['parent']
  #   +++ grandchild1     # set chain to ['parent', 'child1']
  #   +++ grandchild2
  #   ++ child2           # <- set chain to ['parent'] again
  #   + parent2           # <- set chain to [] again
  #
  def trim_parent_chain(key = nil)
    new_chain = []
    @parent_chain.each.with_index do |parent, i|
      if key == parent.key
        new_chain = @parent_chain[0..i]
        break
      end
    end

    @parent_chain = new_chain
  end


  def add_child_result(parent, section, parsed)
    fail "Orphaned child #{section.key}" if parent.nil?
    parent.add_child(section.key, parsed)
  end

  def add_root_result(root, section, parsed)
    @parent_chain.clear

    if section.recurring?
      root[section.key] ||= []
      root[section.key] << parsed
    else
      root[section.key] = parsed
    end
  end
end
