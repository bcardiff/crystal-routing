require "./../spec_helper"
require "http"

class FooController
  include Routing::WithContext

  def method1
    10
  end

  def method2
    20
  end

  def page
    routing_context.params["page_id"]
  end

  def home
    "home page"
  end
end

class BarController
  include Routing::WithContext

  def method3
    "30"
  end
end

module SpecHttp
  class Sample1
    def process_route(request, &block)
    end

    include Routing::HttpRequestRouter

    get "m1", "foo#method1"
    get "m2", "foo#method2"
    post "m3", "bar#method3"

    get "m1", "foo#method2" # this should not be reachable

    get "p/:page_id", "foo#page"

    root "foo#home"
  end
end

def routes
  SpecHttp::Sample1.new
end

def get(path)
  HTTP::Request.new("GET", path)
end

def post(path)
  HTTP::Request.new("POST", path)
end

describe Routing::HttpRequestRouter do
  it "should build routes" do
    routes.should_not be_nil
  end

  it "should exec route" do
    routes.route(get("/m1")).should eq(10)
    routes.route(get("/m2")).should eq(20)
    routes.route(post("/m3")).should eq("30")
  end

  it "should get params from route part" do
    routes.route(get("/p/help")).should eq("help")
  end

  it "should get home page" do
    routes.route(get("/")).should eq("home page")
  end
end
