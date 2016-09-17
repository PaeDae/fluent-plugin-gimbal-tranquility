require 'spec_helper'

RSpec.describe Fluent::Tranquility::Writer do
  describe '#call' do
    subject { instance.call(chunk) }

    let(:instance) { described_class.new }

    context 'when handling a chunk of data' do
      let(:chunk) { double }

      let(:data) do
        <<~CHUNK
        {"key":"value"}\n
        {"key2":"value2"}\n
        {"key3":"value3"}\n
        CHUNK
      end

      let(:pusher) { instance_double(Fluent::Tranquility::Pusher) }

      before do
        instance.pusher = pusher
        allow(chunk).to receive(:read).and_return(data)
        allow(pusher).to receive(:call).and_return(true)
      end

      it { is_expected.to eq(true) }

      it 'pushes the data' do
        expect(pusher).to receive(:call).with(data)
        subject
      end
    end
  end
end
