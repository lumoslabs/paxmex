require 'spec_helper'
require 'yaml'

describe Paxmex::Schema do
  let(:schema_file_epa) { File.expand_path('../config/epa.yml', File.dirname(__FILE__)) }
  let(:schema_hash) { YAML.load_file(schema_file_epa) }
  let(:schema) { Paxmex::Schema.new(schema_hash) }

  describe '#parent_section?' do
    it 'is true if at least other record defines it as a parent' do
      expect(schema.parent_section?('SUMMARY_OF_CHARGE')).to be true
    end

    it 'is false if no other records define it as a parent' do
      expect(schema.parent_section?('RECORD_CHARGE')).to be false
    end
  end

end
