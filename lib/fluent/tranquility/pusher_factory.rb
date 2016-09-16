module Fluent
  module Tranquility
    class PusherFactory
      def self.call(*args)
        new.call(*args)
      end

      def call(params = {})
        connection = connection_for(params[:url])
        Pusher.new(connection, params[:dataset])
      end

      private

      def connection_for(url)
        Faraday.new(url: url) do |f|
          f.request :retry, max:                 5,
                            interval:            0.1,
                            interval_randomness: 0.5,
                            backoff_factor:      2

          f.connection :net_http_persistent
        end
      end
    end
  end
end
