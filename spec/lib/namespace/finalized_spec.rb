RSpec.describe Dawn::Namespace::Finalized do
  let(:foo) { double }
  let(:finalized_namespace) { described_class.new(instances: { foo: foo }) }

  describe '#get' do
    context 'when key is registered' do
      it 'returns corresponding instance' do
        expect(finalized_namespace.get(key: :foo)).to eq foo
      end
    end

    context 'when key is not registered' do
      it 'raises an error' do
        expect { finalized_namespace.get(key: :bar) }.to raise_error(Dawn::InstanceNotRegisteredError)
      end
    end
  end  
end
