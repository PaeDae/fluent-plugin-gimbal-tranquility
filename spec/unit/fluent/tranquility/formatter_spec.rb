require 'spec_helper'

RSpec.describe Fluent::Tranquility::Formatter do
  describe '#call' do
    let(:instance) { described_class.new }

    subject { instance.call(_tag, _time, record) }

    context 'when formatting a normal message chunk' do
      let(:_tag) { 'TAG' }
      let(:_time) { Time.now }
      let(:record) { { 'KEY' => 'VALUE' } }

      let(:expected) { %({"KEY":"VALUE"}\n) }

      it { is_expected.to eq(expected) }
    end
  end
end
