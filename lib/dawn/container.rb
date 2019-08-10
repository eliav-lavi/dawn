module Dawn
  class Container
    class << self
      def build(namespace_requests)
        namespaces = namespace_requests.each_with_object({}) do |request, hash|
          raise Dawn::NamespaceAlreadyRegisteredError if hash.key?(request.name)
          hash[request.name] = request.process
        end

        new(namespaces: namespaces)
      end
    end

    def initialize(namespaces:)
			@namespaces = namespaces
		end

    def fetch(namespace:, key:)
      raise Dawn::NamespaceNotRegisteredError unless @namespaces.key?(namespace)
			@namespaces[namespace].get(key: key)
		end
  end
end