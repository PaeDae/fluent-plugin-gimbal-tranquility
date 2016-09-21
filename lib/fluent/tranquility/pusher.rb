module Fluent
  module Tranquility
    class Pusher
      attr_accessor :connection

      def initialize(connection, dataset)
        @connection = connection
        @dataset    = dataset
      end

      def call(data)
        res = connection.post("/v1/post/#{dataset}") do |req|
          req.headers['Content-Type'] = 'text/plain'
          req.body = data
        end

        res.success?
      end

      private

      attr_reader :dataset
    end
  end
end
