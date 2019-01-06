RSpec.describe ActiveNetworkRecord::Attributes do
  subject(:attributes_record) do
    Class.new do
      include ActiveNetworkRecord::Attributes
    end
  end
  let(:attributes_record_instance) { attributes_record.new(attributes) }

  describe '#initialize' do
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

      it 'does set the valid attributes' do
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
        expect { attributes_record.attributes = [:test] }.to(
          change { attributes_record.attributes }.from([]).to([:test])
        )
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
    context 'with setted params' do
      it 'appends the old params to the new ones'
    end
  end

  describe '.dirty' do
    let(:attributes) { { key: :value } }

    before do
      attributes_record.attributes = [:key]
    end

    context 'without changes' do
      it 'returns false' do
        expect(attributes_record_instance.dirty).to be_falsy
      end
    end
    context 'with changes' do
      it 'returns true' do
        expect { attributes_record_instance.write_attribute :key, :value }.to(
          change { attributes_record_instance.dirty }.from(false).to(true)
        )
      end
    end
  end

  describe '.dirty?' do
    let(:attributes) { { key: :value } }

    before do
      attributes_record.attributes = [:key]
    end

    context 'without changes' do
      it 'returns false' do
        expect(attributes_record_instance.dirty?).to be_falsy
      end
    end

    context 'with changes' do
      it 'returns true' do
        expect { attributes_record_instance.write_attribute :key, :value }.to(
          change { attributes_record_instance.dirty? }.from(false).to(true)
        )
      end
    end
  end

  describe '.dirty!' do
    let(:attributes) { { key: :value } }

    context 'with a dirty instance' do
      before { attributes_record_instance.instance_variable_set :@dirty, true }
      it 'set dirty to true' do
        attributes_record_instance.dirty!
        expect(attributes_record_instance.dirty?).to eq(true)
      end
    end
    context 'with a non dirty instance' do
      it 'set dirty to true' do
        expect { attributes_record_instance.dirty! }.to(
          change { attributes_record_instance.dirty? }.from(false).to(true)
        )
      end
    end
  end

  describe '.attributes' do
    before do
      attributes_record.attributes = %i[key key2]
    end

    context 'with all setted values' do
      let(:attributes) { { key: :value, key2: :value2 } }
      it 'returns every setted value' do
        expect(attributes_record_instance.attributes).to eq(attributes.with_indifferent_access)
      end
    end

    context 'with some setted values' do
      let(:attributes) { { key: :value } }

      it 'returns every setted value' do
        expect(attributes_record_instance.attributes[:key]).to eq(:value)
      end
      it 'returns nil on non setted values' do
        expect(attributes_record_instance.attributes[:key2]).to be_nil
      end
    end

    context 'with no setted values' do
      let(:attributes) { {} }

      it 'returns nil on non setted values' do
        expect(attributes_record_instance.attributes[:key2]).to be_nil
      end
    end
  end

  describe '.read_attribute' do
    before do
      attributes_record.attributes = [:key]
    end

    context 'with the value already setted' do
      let(:attributes) { { key: :value} }

      it 'reads its own instance variable' do
        expect(attributes_record_instance.read_attribute :key).to eq(:value)
      end
    end
    context 'with the value non setted' do
      let(:attributes) { {} }

      it 'returns nil' do
        expect(attributes_record_instance.read_attribute :key).to be_nil
      end
    end
  end

  describe '.write_attribute' do
    let(:attributes) { {} }

    before do
      attributes_record.attributes = [:key]
    end

    context 'with a non existing attribute' do
      it 'throws an exception' do
        expect { attributes_record_instance.write_attribute :key2, :test }.to(
          raise_exception(ArgumentError)
        )
      end
    end

    context 'with an existing attribute' do
      it 'assigns the value to an instance value' do
        expect { attributes_record_instance.write_attribute :key, :test }.to(
          change { attributes_record_instance.read_attribute :key }.from(nil).to(:test)
        )
      end

      it 'returns the assigned value' do
        expect(
          attributes_record_instance.write_attribute(:key, :test2)
        ).to eq(:test2)
      end
    end
  end

  describe '.assign_attributes' do
    before do
      attributes_record.attributes = [:key, :key2]
    end

    context 'with valid attributes' do
      let(:attributes_to_assign) { { key: :value } }

      context 'with old values' do
        let(:attributes) { { key2: :value2 } }

        it 'set dirty to true' do
          expect { attributes_record_instance.assign_attributes(attributes_to_assign) }.to(
            change { attributes_record_instance.dirty? }.from(false).to(true)
          )
        end

        it 'changes attributes to the setted ones' do
          expect { attributes_record_instance.assign_attributes(attributes_to_assign) }.to(
            change { attributes_record_instance.attributes }.from(attributes).to(attributes_to_assign.merge(key2: :value2))
          )
        end
      end

      context 'without old values' do
        let(:attributes) { { } }

        it 'set dirty to true' do
          expect { attributes_record_instance.assign_attributes(attributes_to_assign) }.to(
            change { attributes_record_instance.dirty? }.from(false).to(true)
          )
        end

        it 'changes attributes to the setted ones' do
          expect { attributes_record_instance.assign_attributes(attributes_to_assign) }.to(
            change { attributes_record_instance.attributes }.from(attributes).to(attributes_to_assign)
          )
        end
      end

    end

    context 'with invalid attributes' do
      let(:attributes) { { } }
      let(:attributes_to_assign) { { key3: :value } }


      it 'keeps dirty as false' do
        expect do
          begin
            attributes_record_instance.assign_attributes(attributes_to_assign)
          rescue
          end
        end.not_to(
          change { attributes_record_instance.dirty? }
        )
      end

      it 'throws an exception' do
        expect { attributes_record_instance.assign_attributes attributes_to_assign }.to(
          raise_exception(ArgumentError)
        )
      end
    end
  end
end
