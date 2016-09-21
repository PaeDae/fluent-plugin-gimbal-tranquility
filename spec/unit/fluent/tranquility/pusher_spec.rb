require 'spec_helper'

RSpec.describe Fluent::Tranquility::Pusher do
  describe '#call' do
    subject { instance.call(data) }

    let(:instance) { described_class.new(connection, dataset) }

    let(:connection) { instance_double(Faraday::Connection) }
    let(:dataset) { 'DATASET' }
    let(:data) { 'DATA' }
    let(:request) { instance_double(Faraday::Request) }
    let(:response) { instance_double(Faraday::Response) }
    let(:headers) { instance_double(Hash) }

    before do
      allow(connection).to receive(:post).and_return(response).and_yield(request)
      allow(response).to receive(:success?).and_return(true)
      allow(request).to receive(:headers).and_return(headers)
      allow(request).to receive(:body=)
      allow(headers).to receive(:[]=)
    end

    it { is_expected.to eq(true) }

    it 'posts the data to Tranquility' do
      expect(connection).to receive(:post).with('/v1/post/DATASET')
      subject
    end

    it 'sends the correct body' do
      expect(request).to receive(:body=).with('DATA')
      subject
    end

    it 'sets the request Content-Type to text/plain' do
      expect(headers).to receive(:[]=).with('Content-Type', 'text/plain')
      subject
    end
  end
end
