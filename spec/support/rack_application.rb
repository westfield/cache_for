require 'rubygems'
require 'rack'
require 'cache_for/rack'

class HelloCacheFor

  def new(redis_uri)
    @cache_for = CacheFor::Base.new(redis_uri)
  end

  def call(env)

    [200, {"Content-Type" => "text/html"}, "Hello Rack!"]
  end
end

Rack::Handler::Mongrel.run HelloCacheFor.new, :Port => 9292
