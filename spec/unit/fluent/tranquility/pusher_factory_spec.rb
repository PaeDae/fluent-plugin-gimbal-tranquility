require 'spec_helper'

RSpec.describe Fluent::Tranquility::PusherFactory do
  describe '.call' do
    subject { described_class.call(params) }

    let(:params) { { url: 'http://example.com', dataset: 'DATASET' } }

    let(:pusher) { instance_double(Fluent::Tranquility::Pusher) }
    let(:connection) { instance_double(Faraday::Connection) }

    before do
      allow(Fluent::Tranquility::Pusher).to receive(:new).and_return(pusher)
      allow(Faraday).to receive(:new).and_return(connection)
    end

    it { is_expected.to eq(pusher) }

    it 'sets up the pusher correctly' do
      expect(Fluent::Tranquility::Pusher).to receive(:new).with(connection, 'DATASET')
      subject
    end
  end
end
