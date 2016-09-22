require 'forwardable'
require 'faraday'
require 'time'

module Fluent
  module Tranquility
    class Plugin < BufferedOutput
      extend Forwardable

      desc 'Tranquility URL'
      config_param :url, :string

      desc 'Druid Dataset'
      config_param :dataset, :string

      config_section :retries, multi: false, init: true do
        config_param :max, :integer, default: 5
        config_param :interval, :float, default: 1
        config_param :interval_randomness, :float, default: 0.5
        config_param :backoff_factor, :float, default: 2
      end

      def start
        super
        @writer = Writer.new.tap do |w|
          w.pusher = PusherFactory.call(url: @url, dataset: @dataset, retries: @retries.to_h)
        end

        @formatter = Formatter.new
      end

      private

      attr_reader :writer, :formatter

      def_delegator :writer, :call, :write
      def_delegator :formatter, :call, :format
    end
  end
end
