require "http/server"
require "../src/routing"

class FooController
  include Routing::Routable

  def method1
    HTTP::Response.ok "text/plain", "method1"
  end

  def method2
    HTTP::Response.ok "text/plain", routing_context.params["id"]
  end
end

class BarController
  include Routing::Routable

  def method2
    HTTP::Response.ok "text/plain", "method2"
  end
end

module App
  class Routes
    include Routing::HttpRequestRouter

    get "m1", "foo#method1"
    post "m2", "bar#method2"
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
