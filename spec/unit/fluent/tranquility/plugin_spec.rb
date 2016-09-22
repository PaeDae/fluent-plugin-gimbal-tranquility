require 'spec_helper'

RSpec.describe Fluent::Tranquility::Plugin do
  let(:driver) do
    Fluent::Test::BufferedOutputTestDriver.new(Fluent::Tranquility::Plugin).configure(configuration)
  end

  let(:configuration) do
    <<~EOF
      type tranquility
      url http://example.com
      dataset events
    EOF
  end

  describe '.start' do
    subject { driver.instance.start }

    let(:pusher) { instance_double(Fluent::Tranquility::Pusher) }
    let(:writer) { instance_double(Fluent::Tranquility::Writer) }
    let(:formatter) { instance_double(Fluent::Tranquility::Formatter) }

    before do
      Fluent::Test.setup
      allow(Fluent::Tranquility::PusherFactory).to receive(:call).and_return(pusher)
      allow(Fluent::Tranquility::Writer).to receive(:new).and_return(writer)
      allow(Fluent::Tranquility::Formatter).to receive(:new).and_return(formatter)
      allow(writer).to receive(:pusher=)
    end

    it 'sets up a writer' do
      expect(Fluent::Tranquility::Writer).to receive(:new)
      subject
    end

    it 'sets up a formatter' do
      expect(Fluent::Tranquility::Formatter).to receive(:new)
      subject
    end

    it 'sets up a pusher' do
      params = { url: 'http://example.com',
                 dataset: 'events',
                 retries: { max: 5,
                            interval: 1,
                            interval_randomness: 0.5,
                            backoff_factor: 2 } }

      expect(Fluent::Tranquility::PusherFactory).to receive(:call).with(params)
      subject
    end

    it 'attaches the right pusher to the writer' do
      expect(writer).to receive(:pusher=).with(pusher)
      subject
    end
  end
end
