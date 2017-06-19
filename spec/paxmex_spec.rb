require 'spec_helper'

describe Paxmex do
  shared_examples 'a schema proxy' do
    it 'returns a proxy object' do
      is_expected.to be_a(Paxmex::SchemaProxy)
    end

    it 'is able to load files' do
      expect { subject.load_file(file) }.not_to raise_error
    end

    it 'is able to parse in-memory content' do
      expect { subject.parse(File.read(file)) }.not_to raise_error
    end
  end

  describe '.cbnot' do
    subject { Paxmex.cbnot }
    let(:file) { File.expand_path('../support/dummy_cbnot_raw', __FILE__) }

    it_behaves_like 'a schema proxy'
  end

  describe '.epa' do
    subject { Paxmex.epa }
    let(:file) { File.expand_path('../support/dummy_epa_raw', __FILE__) }

    it_behaves_like 'a schema proxy'
  end

  describe '.epraw' do
    subject { Paxmex.epraw }
    let(:file) { File.expand_path('../support/dummy_epraw_raw', __FILE__) }

    it_behaves_like 'a schema proxy'
  end

  describe '.eptrn' do
    subject { Paxmex.eptrn }
    let(:file) { File.expand_path('../support/dummy_eptrn_raw', __FILE__) }

    it_behaves_like 'a schema proxy'
  end
end
