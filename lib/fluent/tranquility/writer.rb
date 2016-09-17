module Fluent
  module Tranquility
    class Writer
      attr_accessor :pusher

      def call(chunk)
        pusher.call(chunk.read)
      end
    end
  end
end
