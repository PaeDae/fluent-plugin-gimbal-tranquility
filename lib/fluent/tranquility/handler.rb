module Fluent
  module Tranquility
    class Handler
      attr_accessor :pusher

      def call(chunk)
        pusher.call(chunk.read)
      end
    end
  end
end
