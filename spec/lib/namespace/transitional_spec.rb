RSpec.describe Dawn::Namespace::Transitional do
  let(:foo) { double }

  describe '#set' do
    context 'when namespace is not registered with key' do
      let(:transitional_namespace) { described_class.new }

      it 'returns a new Dawn::Namespace::Transitional' do
        expect(transitional_namespace.set(key: :foo, instance: foo)).to be_a Dawn::Namespace::Transitional
        expect(transitional_namespace.set(key: :foo, instance: foo)).not_to eq transitional_namespace
      end
    end

    context 'when namespace is already registered with key' do
      let(:transitional_namespace) { described_class.new(instances: { foo: foo }) }

      it 'raises an error' do
        expect { transitional_namespace.set(key: :foo, instance: foo) }.to raise_error(Dawn::InstanceAlreadyRegisteredError)
      end
    end
  end

  describe '#finalize' do
    let(:transitional_namespace) { described_class.new(instances: { foo: foo }) }

    it 'returns a Dawn::Namespace::Finalized' do
      expect(transitional_namespace.finalize).to be_a Dawn::Namespace::Finalized
    end
  end
end