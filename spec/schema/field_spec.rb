require 'paxmex/schema/field'

describe Paxmex::Schema::Field do
  describe '#parse' do
    context 'decimals' do
      let(:field) { Paxmex::Schema::Field.new(type: 'decimal') }

      it 'parses debit codes correctly' do
        expect(field.parse('0000000011A')).to eq(1.11)
      end

      it 'parses credit codes correctly' do
        expect(field.parse('0000000227}').to_f).to eq(-22.70)
      end
    end

    context 'dates' do
      let(:field) { Paxmex::Schema::Field.new(type: 'date') }

      it 'parses dates correctly using a default pattern' do
        expect(field.parse('09202017')).to eq(Date.parse('2017-09-20'))
      end

      it "returns nil if the field can't be parsed" do
        expect(field.parse('')).to eq(nil)
      end
    end

    context 'numeric values' do
      let(:field) { Paxmex::Schema::Field.new(type: 'numeric') }

      it 'parses numeric values correctly using a default pattern' do
        expect(field.parse('1234')).to eq(1234)
      end
    end

    context 'julian dates' do
      let(:field) { Paxmex::Schema::Field.new(type: 'julian') }

      it 'parses julian dates correctly' do
        expect(field.parse('2013365')).to eq(Date.parse('2013-12-31'))
      end
    end

    context 'date patterns' do
      let(:field) { Paxmex::Schema::Field.new(type: 'date(%m%d%Y)') }

      it 'parses correctly using the given date pattern' do
        expect(field.parse('09202017')).to eq(Date.parse('2017-09-20'))
      end

      it "returns nil if the field doesn't match the pattern" do
        expect(field.parse('')).to eq(nil)
      end
    end

    context 'time patterns' do
      let(:field) { Paxmex::Schema::Field.new(type: 'time(%m%d%Y %H:%M:%S)') }

      it 'parses correctly using the given time pattern' do
        expect(field.parse('09202017 08:20:14')).to eq(Time.new(2017, 9, 20, 8, 20, 14))
      end

      it "returns nil if the field doesn't match the pattern" do
        expect(field.parse('')).to eq(nil)
      end
    end
  end
end
