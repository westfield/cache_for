require "spec_helper"
require 'cache_for'

describe CacheFor::Base do

  describe "can read" do
    subject { CacheFor::Base.new } # the test environment must have a redis instance running on the default localhost:6379
    let(:now) { Time.now.to_s }
    let(:key) {__FILE__}

    it "what it wrote" do
      subject.write(key, now)
      subject.read(key).should == now
    end

    it "will not read what in did not write" do
      subject.read('aoue').should == subject.class::CacheMiss
    end

  end
end
