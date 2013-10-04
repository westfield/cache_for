# CacheFor

A simple wrapper around a redis store to implement keys with a timestamp.

The "For" in CacheFor refers to 1) the content labeled by the key name, and 2) the cache duration.

## Installation
Ruby ~>2.0.0 required.

Add this gem to your application's Gemfile:

    gem 'cache_for'

## Usage
In your app, wherever you need some caching sweetness

    CacheForApp = CacheFor::Base.new()
    values = CacheForApp.fetch('Product-options') { Product.all.collect {|product| [product.name, product.id]} }

Optionally, set a redis endpoint

    CacheFor::Base.new( 'redis://localhost:6379' )

Optionally, set a default TTL

    CacheFor::Base.new( default_secs: 600 )
