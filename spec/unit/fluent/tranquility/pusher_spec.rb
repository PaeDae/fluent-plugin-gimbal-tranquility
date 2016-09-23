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
    let(:params) { instance_double(Hash) }
    let(:options) { double }

    before do
      allow(connection).to receive(:post).and_return(response).and_yield(request)
      allow(response).to receive(:success?).and_return(true)
      allow(request).to receive(:headers).and_return(headers)
      allow(request).to receive(:body=)
      allow(headers).to receive(:[]=)
      allow(request).to receive(:params).and_return(params)
      allow(params).to receive(:[]=)
      allow(request).to receive(:options).and_return(options)
      allow(options).to receive(:timeout=)
      allow(options).to receive(:open_timeout=)
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

    it 'sets the request as async' do
      expect(params).to receive(:[]=).with('async', true)
      subject
    end

    it 'sets the request timeout' do
      expect(options).to receive(:timeout=).with(60)
      subject
    end

    it 'sets the request connection open timeout' do
      expect(options).to receive(:open_timeout=).with(60)
      subject
    end
  end
end
