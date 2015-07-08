require "./../spec_helper"
require "http"

class FooController
  def method1
    10
  end

  def method2
    20
  end
end

class BarController
  def method3
    "30"
  end
end

module SpecHttp
  http_router Sample1 do
    get "m1", "foo#method1"
    get "m2", "foo#method2"
    post "m3", "bar#method3"

    get "m1", "foo#method2" # this should not be reachable
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

describe Routing::HttpRouter do
  it "should build routes" do
    routes.should_not be_nil
  end

  it "should exec route" do
    routes.route(get("/m1")).should eq(10)
    routes.route(get("/m2")).should eq(20)
    routes.route(post("/m3")).should eq("30")
  end
end
