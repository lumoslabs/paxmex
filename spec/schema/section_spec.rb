require 'paxmex/schema/section'

describe Paxmex::Schema::Section do
  let(:key_child) { 'EXAMPLE_CHILD' }
  let(:key_parent) { 'EXAMPLE_PARENT' }
  let(:data_child) { { 'PARENT' => key_parent } }
  let(:data_parent) { {} }

  let(:child_section) { Paxmex::Schema::Section.new(key_child, data_child) }
  let(:parent_section) { Paxmex::Schema::Section.new(key_parent, data_parent) }

  describe '#child?' do
    it 'is true for a record with a parent' do
      child_section.child?.should be true
    end

    it 'is false for a record without a parent' do
      parent_section.child?.should be false
    end
  end

end
