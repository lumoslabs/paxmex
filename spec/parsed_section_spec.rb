require 'spec_helper'

describe Paxmex::ParsedSection do
  let(:section) { Paxmex::Schema::Section.new('BABA', {}) }
  subject(:parsed_section) { Paxmex::ParsedSection.new(section, {}) }

  it { is_expected.to be_a_kind_of(Hash) }

  it 'has a key' do
    expect(parsed_section.key).to eq('BABA')
  end
end
