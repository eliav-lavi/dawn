require 'dawn/container'
require 'dawn/namespace/request'

RSpec.describe Dawn do
	describe 'container with namespaces' do
		let(:instance_a) { double }
		let(:instance_b) { double }
		let(:instance_c) { double }
		let(:instance_d) { double }

		let(:foo_namespace_request) do
			Dawn::Namespace::Request.new(name: :foo) do |namespace|
				namespace
					.set(key: :instance_a, instance: instance_a)
					.set(key: :instance_b, instance: instance_b)
			end
		end

		let(:bar_namespace_request) do 
			Dawn::Namespace::Request.new(name: :bar) do |namespace|
				namespace
					.set(key: :instance_c, instance: instance_c)
					.set(key: :instance_d, instance: instance_d)
			end
		end

		let(:container) { Dawn::Container.build([foo_namespace_request, bar_namespace_request]) }

		it 'allows fetching registered instances from namespaces' do
			expect(container.fetch(namespace: :foo, key: :instance_a)).to eq instance_a
			expect(container.fetch(namespace: :foo, key: :instance_b)).to eq instance_b
			expect(container.fetch(namespace: :bar, key: :instance_c)).to eq instance_c
			expect(container.fetch(namespace: :bar, key: :instance_d)).to eq instance_d
		end
	end
end
