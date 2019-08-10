require 'dawn/namespace/transitional'

module Dawn
  module Namespace
    class Request
      attr_reader :name

      def initialize(name:, &proc)
        @name = name
        @proc = proc
      end
  
      def process
        @proc.call(Transitional.new).finalize
      end
    end
  end
end
