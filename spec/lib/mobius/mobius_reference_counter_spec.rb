# coding: utf-8
# frozen_string_literal: true


require 'spec_helper'
require 'mobius_reference_counter'

describe MobiusReferenceCounter do
  let(:redis_client) { double('redis_client') }
  let(:reference_counter_key) { 'git-receive-pack-reference-counter:/test/path' }
  let(:mobius_reference_counter) { MobiusReferenceCounter.new('/test/path') }

  before do
    allow(mobius_reference_counter).to receive(:redis_client).and_return(redis_client)
    $logger = double('logger').as_null_object
  end

  it 'increases and set the expire time of a reference count for a path' do
    expect(redis_client).to receive(:incr).with(reference_counter_key)
    expect(redis_client).to receive(:expire).with(reference_counter_key, MobiusReferenceCounter::REFERENCE_EXPIRE_TIME)
    expect(mobius_reference_counter.increase).to be(true)
  end

  it 'decreases the reference count for a path' do
    allow(redis_client).to receive(:decr).and_return(0)
    expect(redis_client).to receive(:decr).with(reference_counter_key)
    expect(mobius_reference_counter.decrease).to be(true)
  end

  it 'warns if attempting to decrease a counter with a value of one or less, and resets the counter' do
    expect(redis_client).to receive(:decr).and_return(-1)
    expect(redis_client).to receive(:del)
    expect($logger).to receive(:warn).with('Reference counter for /test/path decreased when its value was less than 1. Reseting the counter.')
    expect(mobius_reference_counter.decrease).to be(true)
  end

  it 'get the reference count for a path' do
    allow(redis_client).to receive(:get).and_return(1)
    expect(mobius_reference_counter.value).to be(1)
  end
end
