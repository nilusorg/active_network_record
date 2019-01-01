RSpec.describe ActiveNetworkRecord::Attributes do
  subject(:attributes_record) do
    Class.new do
      include ActiveNetworkRecord::Attributes
    end
  end

  describe '#initialize' do
    let(:attributes_record_instance) { attributes_record.new(attributes) }

    before do
      attributes_record.attributes = [:key]
    end

    context 'with all valid attributes' do
      let(:attributes) { { key: :value } }

      # it 'executes the original initializer'
      it 'sets the attributes values' do
        expect(attributes_record_instance.attributes).to eq(attributes.with_indifferent_access)
      end
    end

    context 'with all invalid attributes' do
      let(:attributes) { { key2: :value } }

      # it 'executes the original initializer'
      it "doesn't set the attributes" do
        expect(attributes_record_instance.attributes).to be_empty
      end
    end

    context 'with some invalid attributes' do
      let(:attributes) { { key2: :value, key: :value } }

      # it 'executes the original initializer'
      it "doesn't set the invalid attributes" do
        expect(attributes_record_instance.attributes).not_to have_key(:key2)
      end

      it "does set the valid attributes" do
        expect(attributes_record_instance.attributes).to have_key(:key)
      end
    end
  end

  describe '#attributes' do
    context 'without setted params' do
      it "doesn't throw exceptions" do
        expect { attributes_record.attributes }.not_to raise_error
      end

      it 'returns an empty array' do
        expect(attributes_record.attributes).to be_empty
      end
    end
  end

  describe '#attributes=' do
    context 'without setted params' do
      it "doesn't throw exceptions" do
        expect { attributes_record.attributes = [:test] }.not_to raise_error
      end

      it 'returns an empty array' do
        expect { attributes_record.attributes = [:test] }.to change { attributes_record.attributes }.from([]).to([:test])
      end

      context 'with other class setting their own attributes' do
        let(:attributes_record_clone) do
          Class.new do
            include ActiveNetworkRecord::Attributes
          end
        end

        before do
          attributes_record_clone.attributes = [:test]
        end

        it 'keeps original class attributes still empty' do
          expect(attributes_record.attributes).to be_empty
        end

        it 'set new one to a new array with values :test' do
          expect(attributes_record_clone.attributes).to eq([:test])
        end
      end
    end
  end

  describe '.dirty' do
    context 'without changes' do
      it 'returns false'
    end
    context 'with changes' do
      it 'returns true'
    end
  end

  describe '.dirty?' do
    context 'without changes' do
      it 'returns false'
    end
    context 'with changes' do
      it 'returns true'
    end
  end

  describe '.attributes' do
    it 'returns every setted value'
    it 'returns nil on non setted values'
  end

  describe '.read_attribute' do
    it 'reads its own instance variable'
  end

  describe '.write_attribute' do
    context 'with a non existing attribute' do
      it 'throws an exception'
    end
    context 'with an existing attribute' do
      it 'assigns the value to an instance value'
      it 'returns the assigned value'
    end
  end

  describe '.assign_attributes' do
    context 'with valid attributes' do
      it 'invokes write_attribute for every attribute'
    end
    context 'with invalid attributes' do
      it 'raises a descriptive exception'
    end
  end
end
