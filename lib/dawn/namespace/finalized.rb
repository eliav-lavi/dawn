require 'dawn'

module Dawn
  module Namespace
    class Finalized
      def initialize(instances:)
        @instances = instances
      end

      def get(key:)
        raise Dawn::InstanceNotRegisteredError unless @instances.key?(key)
        @instances[key]
      end
    end
  end
end
