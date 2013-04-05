require 'paxmex/schema/field'

describe Paxmex::Schema::Field do
  let(:field) { Paxmex::Schema::Field.new }

  describe '#parse_decimal' do
    it 'parses debit codes correctly' do
      field.parse_decimal('0000000011A').to_f.should == 1.11
    end

    it 'parses credit codes correctly' do
      field.parse_decimal('0000000227}').to_f.should == -22.70
    end
  end

  describe '#parse_julian_date' do
    it 'parses julian dates correctly' do
      field.parse_julian_date('2013365').should == Date.parse('2013-12-31')
    end
  end
end
