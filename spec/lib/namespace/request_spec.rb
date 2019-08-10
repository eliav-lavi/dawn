RSpec.describe Dawn::Namespace::Request do
  let(:namespace_request) { described_class.new(name: anything, &proc) }

  let(:proc) { lambda { |namespace| namespace.do_stuff(with: :data) } }

  describe '#process' do
    let(:transitional_namespace) { instance_double(Dawn::Namespace::Transitional, finalize: double) }

    it 'calls proc with a new Dawn::Namespace::Transitional' do
      expect(proc).to receive(:call)
        .with(a_kind_of(Dawn::Namespace::Transitional))
        .and_return(transitional_namespace)

      namespace_request.process
    end

    it 'calls #finalize upon returned transitional_namespace' do
      allow(proc).to receive(:call)
        .with(a_kind_of(Dawn::Namespace::Transitional))
        .and_return(transitional_namespace)

      expect(transitional_namespace).to receive(:finalize)
      namespace_request.process
    end
  end
end