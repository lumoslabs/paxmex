require 'paxmex/parsed_section'

describe Paxmex::ParsedSection do
  let(:section) { Paxmex::Schema::Section.new('BABA', {}) }
  subject(:parsed_section) { Paxmex::ParsedSection.new(section, {}) }

  it { should be_a_kind_of(Hash) }

  it 'has a key' do
    parsed_section.key.should == 'BABA'
  end

end
