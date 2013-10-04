# CacheFor

A simple wrapper around a redis store to implement keys with a timestamp.

The "For" in CacheFor refers to 1) the content labeled by the key name, 2) the cache duration, and 3) the framework (e.g. Rails)

## Installation

Add these gems to your application's Gemfile:

### Rails

    gem 'cache_for'
    gem 'redis'

### Rack

    gem 'cache_for'
    gem 'redis-rack-cache'

### Sinatra
Add `register Sinatra::Cache`  to your config.ru

    gem 'cache_for'
    gem 'redis-sinatra'

## Usage
In your app, wherever you need some caching sweetness (Rails example)

    RedisCache = CacheFor::Base.new
    values = RedisCache.fetch('Product-options') { Product.all.collect {|product| [product.name, product.id]} }
