module Fluent
  module Tranquility
    class Formatter
      def call(_tag, _time, record)
        begin
          record.to_json + "\n"
        rescue Encoding::UndefinedConversionError
          record.each do |k, v|
            record[k] = v.force_encoding(Encoding::UTF_8)
          end
          return record.to_json + "\n"
        end
      end
    end
  end
end
