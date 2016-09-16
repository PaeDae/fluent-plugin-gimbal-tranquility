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

      def start
        super
        @handler = Handler.new.tap do |h|
          h.pusher = PusherFactory.call(url: @url, dataset: @dataset)
        end

        @formatter = Formatter.new
      end

      private

      attr_reader :handler, :formatter

      def_delegator :handler, :call, :write
      def_delegator :formatter, :call, :format
    end
  end
end
