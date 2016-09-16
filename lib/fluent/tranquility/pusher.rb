module Fluent
  module Tranquility
    class Pusher
      attr_accessor :adapter

      def initialize(adapter, dataset)
        @adapter = adapter
        @dataset = dataset
      end

      def call(data)
        adapter.post("/v1/post/#{dataset}") do |req|
          req.headers['Content-Encoding'] = 'gzip'
          req.headers['Content-Type'] = 'text/plain'
          req.body = data
        end
      end

      private

      attr_reader :dataset
    end
  end
end
