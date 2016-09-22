module Fluent
  module Tranquility
    class PusherFactory
      def self.call(*args)
        new.call(*args)
      end

      def call(params = {})
        connection = connection_for(params[:url], params[:retries])
        Pusher.new(connection, params[:dataset])
      end

      private

      def connection_for(url, options = {})
        Faraday.new(url: url) do |f|
          f.request :retry, max:                 options.fetch(:max, 5),
                            interval:            options.fetch(:interval, 1),
                            interval_randomness: options.fetch(:interval_randomness, 0.5),
                            backoff_factor:      options.fetch(:backoff_factor, 2)

          f.adapter :net_http_persistent
        end
      end
    end
  end
end
