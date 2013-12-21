require "spec_helper"
require 'cache_for/base'

shared_examples "cache_time is" do |secs, cache_time|
  before {
    static_time.now.stub(:to_i) { secs }
  }

  it "#{cache_time} when time is #{secs}" do
    CacheFor::Base.new('redis://redis.example.com', default_seconds: duration).cache_time.should == cache_time
  end
end

describe 'CacheFor' do
  describe "#new" do
    context "with nil url" do
      subject { CacheFor::Base.new.redis_store.client }
      its(:scheme) { should eq 'redis' }
      its(:host) { should eq '127.0.0.1' }
      its(:port) { should eq 6379 }
      its(:db) { should eq 0 }
    end

    context "with url" do
      let(:url) { 'redis://dummy.com:6666/6' }
      subject { CacheFor::Base.new(url).redis_store.client }
      its(:scheme) { should eq 'redis' }
      its(:host) { should eq 'dummy.com' }
      its(:port) { should eq 6666 }
      its(:db) { should eq 6 }
    end
  end
end

describe 'CacheFor#cache_time' do

  describe "cache_time" do
    let(:static_time) { double("StaticTime") }

    before {
      stub_const("Time", static_time)
      static_time.stub(:now) { static_time }
    }

    it "Time.now.to_i should be stubbable" do
      static_time.now.stub(:to_i) { 1000 }
      Time.now.to_i.should == 1000
    end

    context "when duration is 10" do
      let(:duration) { 10 }

      it_behaves_like "cache_time is", 1011, 1010
      it_behaves_like "cache_time is", 1001, 1000
      it_behaves_like "cache_time is", 1000, 1000
      it_behaves_like "cache_time is", 999, 990
      it_behaves_like "cache_time is", 550, 550
    end

    context "when duration is 100" do
      let(:duration) { 100 }

      it_behaves_like "cache_time is", 1101, 1100
      it_behaves_like "cache_time is", 1001, 1000
      it_behaves_like "cache_time is", 1000, 1000
      it_behaves_like "cache_time is", 999, 900
      it_behaves_like "cache_time is", 550, 500
    end

    context "when duration is 600" do
      let(:duration) { 600 }

      it_behaves_like "cache_time is", 1601, 1200
      it_behaves_like "cache_time is", 1001, 600
      it_behaves_like "cache_time is", 1000, 600
      it_behaves_like "cache_time is", 999, 600
      it_behaves_like "cache_time is", 550, 0
    end

  end

end
