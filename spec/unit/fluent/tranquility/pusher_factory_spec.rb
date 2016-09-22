require 'spec_helper'

RSpec.describe Fluent::Tranquility::PusherFactory do
  describe 'EXCEPTIONS' do
    subject { described_class::EXCEPTIONS }

    let(:expected) do
      [Errno::ETIMEDOUT,
       Faraday::TimeoutError,
       Faraday::Error::TimeoutError,
       Net::ReadTimeout]
    end

    it { is_expected.to eq(expected) }
  end

  describe '.call' do
    subject { described_class.call(params) }

    let(:params) do
      { url: 'http://example.com',
        dataset: 'DATASET',
        retries: {} }
    end

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
                       interval:            1,
                       interval_randomness: 0.5,
                       backoff_factor:      2,
                       methods:             %w(post),
                       exceptions:          described_class::EXCEPTIONS }

      expect(connection).to receive(:request).with(:retry, retry_params)
      subject
    end
  end
end
