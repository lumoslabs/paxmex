class Paxmex::Schema
  def initialize(schema_hash)
    @schema_hash = schema_hash
  end

  def sections
    @sections ||= @schema_hash.map { |k, v| Section.new(k, v) }
  end

  class Section
    BLOCK_LENGTH = 450

    attr_reader :key, :data

    def initialize(key, data)
      @key = key
      @data = data
    end

    def recurring?
      !!data['RECURRING']
    end

    def abstract?
      !!data['ABSTRACT']
    end

    def trailer?
      !!data['TRAILER']
    end

    def fields
      data['FIELDS']
    end

    def types
      data['TYPES']
    end

    def type_field
      data['TYPE_FIELD']
    end

    def type_mapping
      data['TYPE_MAPPING']
    end

    def section_for_type(type)
      sections_for_types.detect { |t| t.key == type_mapping[type] }
    end

    def length
      recurring? ? nil : BLOCK_LENGTH
    end

    private

    def sections_for_types
      @sections_for_types ||= types.map { |k, v| Section.new(k, v) }
    end
  end
end
