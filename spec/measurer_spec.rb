# frozen_string_literal: true

require 'rspec'
require './app'

describe 'Length Measurer' do
  it 'has the system provided when constructed' do
    m = Measurer.new 'imperial'

    expect(m.system).to eq(:imperial)
  end

  it 'rejects invalid systems' do
    expect { Measurer.new 'foo' }.to raise_error(ArgumentError, /invalid/i)
  end

  it 'should Measure length' do
  end
end
