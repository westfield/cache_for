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

    def read(key)
      @redis_store.get(key)
    end

    def write(key, value)
      @redis_store.set(key, value)
    end

    def cache_miss
      self.class::CacheMiss
    end

    def fetch(name, for_seconds = @default_secs)
      key = "#{name}#{cache_time(for_seconds)}"
      cached = read(key) # #read that should fail always returns an array!?
      if cached != self.class::CacheMiss # FIXME need to investigate results that should fail
        puts "cache hit #{key}" # FIME need logging?
        cached
      else
        puts "cache miss #{key}"
        new_value = yield
  # FIXME add expires value
        write(key, new_value) # apparently not caching `false`
        new_value
      end
    end

  end

end
