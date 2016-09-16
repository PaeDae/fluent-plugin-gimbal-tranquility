require 'spec_helper'

RSpec.describe Fluent::Tranquility::PusherFactory do
  describe '.call' do
    subject { described_class.call(params) }

    let(:params) { { url: 'http://example.com', dataset: 'DATASET' } }

    let(:pusher) { instance_double(Fluent::Tranquility::Pusher) }
    let(:connection) { instance_double(Faraday::Connection) }

    before do
      allow(Fluent::Tranquility::Pusher).to receive(:new).and_return(pusher)
      allow(Faraday).to receive(:new).and_yield(connection).and_return(connection)
      allow(connection).to receive(:request)
      allow(connection).to receive(:adapter)
    end

    it { is_expected.to eq(pusher) }

    it 'sets up the pusher correctly' do
      expect(Fluent::Tranquility::Pusher).to receive(:new).with(connection, 'DATASET')
      subject
    end

    it "sets up the connection's adapter" do
      expect(connection).to receive(:adapter).with(:net_http_persistent)
      subject
    end

    it "sets up the connection's retry policy" do
      retry_params = { max:                 5,
                       interval:            0.1,
                       interval_randomness: 0.5,
                       backoff_factor:      2 }

      expect(connection).to receive(:request).with(:retry, retry_params)
      subject
    end
  end
end
