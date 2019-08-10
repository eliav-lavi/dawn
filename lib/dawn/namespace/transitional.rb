require 'dawn/namespace/finalized'
require 'dawn'

module Dawn
  module Namespace
    class Transitional
      def initialize(instances: {})
        @instances = instances
      end

      def set(key:, instance:)
        raise Dawn::InstanceAlreadyRegisteredError if @instances.key?(key)
        Transitional.new(instances: @instances.merge(Hash[key, instance]))
      end

      def finalize
        Finalized.new(instances: @instances)
      end
    end
  end
end
