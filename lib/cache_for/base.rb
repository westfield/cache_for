require 'cache_for'
require 'time'
require 'redis'
require 'uri'

module CacheFor

  class Base

    DefaultSeconds = 600 # 10 minutes
    DefaultUri = URI::parse("redis://localhost:6379")
    CacheMiss = nil #[] # vailid for Rack?

    def initialize(redis_uri = nil, default_secs: nil)
      redis_uri = to_uri(redis_uri)
      redis_store = Redis.new( host: redis_uri.host, port: redis_uri.port )
      @redis_store, @default_secs = redis_store, (default_secs || Base::DefaultSeconds)
    end


    def to_uri(obj = DefaultUri)
      obj = DefaultUri if obj.nil?
      obj = URI::parse(obj) unless obj.respond_to?(:host)
      obj
    end

    def cache_time(for_seconds)
      # a time integer that remains unchanging for <for_seconds> seconds
      #   rounds down to nearest multiple of <for_seconds>
      (for_seconds * (Time.now.to_i / for_seconds).to_i)
    end

    def get(key)
      begin
        @redis_store.get(key)
      rescue
        self.class::CacheMiss
      end
    end
    alias_method :read, :get

    def set(key, value)
      begin
        @redis_store.set(key, value)
      rescue
      end
    end
    alias_method :write, :set

    def expire(key, for_seconds)
      begin
        @redis_store.expire(key, for_seconds)
      rescue
      end
    end

    def fetch(name, for_seconds = @default_secs)
      key = "#{name}#{cache_time(for_seconds)}"
      cached = get(key)
      if cached != self.class::CacheMiss
        puts "cache hit #{key}"
        cached
      else
        puts "cache miss #{key}"
        new_value = yield
        set(key, new_value) # apparently not storing `false`
        expire(key, for_seconds)
        new_value
      end
    end

  end

end
