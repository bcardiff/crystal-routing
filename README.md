# crystal-routing

[![Build Status](https://travis-ci.org/bcardiff/crystal-routing.svg)](https://travis-ci.org/bcardiff/crystal-routing)

Extensible library to deal with http request and string based routing in Crystal.

Features:

* Building blocks to define others routing/delegation mechanisms
* Compiled time check method invocation

## Installation

Add this to your application's `shard.yml`:

```crystal
dependencies:
  routing:
    github: bcardiff/crystal-routing
```

## Usage

```crystal
# file: app.cr
require "http/server"
require "routing"

class FooController
  include Routing::Routable

  def method1
    HTTP::Response.ok "text/plain", "method1"
  end

  def method2
    HTTP::Response.ok "text/plain", routing_context.params["id"]
  end
end

module App
  class Routes
    include Routing::HttpRequestRouter

    get "m1", "foo#method1"
    get "foo/:id", "foo#method2"
    root "foo#method1"
  end
end

routes = App::Routes.new
server = HTTP::Server.new(8080) do |request|
  routes.route(request)
end

puts "Listening on http://0.0.0.0:8080"
server.listen
```

Run the server
```
$ crystal app.cr
```

Use the server
```
$ curl http://localhost:8080
method1

$ curl http://localhost:8080/m1
method1

$ curl http://localhost:8080/foo/42
42
```

More in samples and specs

## Development

TODO: Write instructions for development

## Contributing

1. Fork it ( https://github.com/bcardiff/crystal-routing/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [bcardiff](https://github.com/bcardiff) Brian J. Cardiff - creator, maintainer
