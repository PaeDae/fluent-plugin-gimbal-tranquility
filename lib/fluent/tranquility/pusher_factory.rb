module Fluent
  module Tranquility
    class PusherFactory
      def self.call(params = {})
        adapter = adapter_for(params[:url])
        Pusher.new(adapter, params[:dataset])
      end

      private

      def adapter_for(url)
        Faraday.new(url: url) do |f|
          f.request :retry, max:                 5,
                            interval:            0.1,
                            interval_randomness: 0.5,
                            backoff_factor:      2

          f.adapter :net_http_persistent
        end
      end
    end
  end
end
