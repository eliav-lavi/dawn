RSpec.describe Dawn::Container do
  describe '.build' do
    let(:foo_namespace_request) do
      Dawn::Namespace::Request.new(name: :foo) do |namespace|
        namespace
        .set(key: :instance, instance: double)
      end
    end

    let(:bar_namespace_request) do 
      Dawn::Namespace::Request.new(name: :bar) do |namespace|
        namespace
        .set(key: :instance, instance: double)
      end
    end

    context 'when namespace_requests names are not all unique' do
      it 'raises a NamespaceAlreadyRegisteredError' do
        expect { Dawn::Container.build([foo_namespace_request, foo_namespace_request]) }
          .to raise_error(Dawn::NamespaceAlreadyRegisteredError)
      end
    end

    context 'when namespace_requests names are all unique' do
      it 'returns a Dawn::Container' do
        expect(Dawn::Container.build([foo_namespace_request, bar_namespace_request])).to be_a Dawn::Container
      end
    end
  end
  
  describe '#fetch' do
    let(:container) { described_class.new(namespaces: namespaces) }
    let(:namespaces) { { foo_namespace: foo_namespace } }
    let(:foo_namespace) { instance_double(Dawn::Namespace::Finalized) }
    let(:bar) { double }

    before do
      allow(foo_namespace).to receive(:get).and_return(bar)
    end

    context 'when namespace is registered' do
      it 'returns instance from namespace' do
        expect(container.fetch(namespace: :foo_namespace, key: :bar)).to eq bar
      end
    end

    context 'when namespace is not registered' do
      it 'raises an error' do
        expect { container.fetch(namespace: :incognito, key: :bar) }.to raise_error(Dawn::NamespaceNotRegisteredError)
      end
    end
  end
end
