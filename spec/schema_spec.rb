require 'paxmex/schema/section'
require 'yaml'

describe Paxmex::Schema do
  let(:schema_file_epa) { File.expand_path('../config/epa.yml', File.dirname(__FILE__)) }
  let(:schema_hash) { YAML.load_file(schema_file_epa) }
  let(:schema) { Paxmex::Schema.new(schema_hash) }

  describe '#parent_section?' do
    it 'is true if at least other record defines it as a parent' do
      schema.parent_section?('SUMMARY_OF_CHARGE').should be true
    end

    it 'is false if no other records define it as a parent' do
      schema.parent_section?('RECORD_CHARGE').should be false
    end
  end

end
