module Fluent
  module Tranquility
    class Formatter
      def call(_tag, _time, record)
        record.to_json + "\n"
      end
    end
  end
end
