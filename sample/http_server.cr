require "http/server"
require "../src/routing"

class FooController
  def method1
    HTTP::Response.ok "text/plain", "method1"
  end
end

class BarController
  def method2
    HTTP::Response.ok "text/plain", "method2"
  end
end

module App
  http_router Routes do
    get "m1", "foo#method1"
    post "m2", "bar#method2"
  end
end

routes = App::Routes.new
server = HTTP::Server.new(8080) do |request|
  routes.route(request)
end

puts "Listening on http://0.0.0.0:8080"
server.listen
