require "spec_helper"
require 'cache_for/base'

shared_examples "cache_time is" do |secs, cache_time|
  before {
    static_time.now.stub(:to_i) { secs }
  }

  it "#{cache_time} when time is #{secs}" do
    CacheFor::Base.new('redis://redis.example.com').cache_time(duration).should == cache_time
  end
end

describe 'CacheFor#cache_time' do

  describe "to_uri" do

    it "handles nil" do
      CacheFor::Base.new.to_uri.to_s.should == 'redis://localhost:6379'
    end

    it "handles string url" do
      CacheFor::Base.new.to_uri('redis://localhost:6379').to_s.should == 'redis://localhost:6379'
    end

    it "handles string url" do
      CacheFor::Base.new.to_uri(URI::parse('redis://localhost:6379')).to_s.should == 'redis://localhost:6379'
    end


    describe "returns a URI" do
      subject { CacheFor::Base.new.to_uri() }
      its(:host) {should == 'localhost'}
      its(:port) {should == 6379}
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
