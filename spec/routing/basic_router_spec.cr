require "./../spec_helper"

class Foo
  include Routing::WithContext

  def method1
    1
  end

  def method2
    2
  end
end

class Bar
  include Routing::WithContext

  def method3
    "3"
  end

  def some
    routing_context.params["id"]
  end
end

module Spec1
  basic_router Sample1 do
    on "m1", "foo#method1"
    on "m2", "foo#method2"
    on "m3", "bar#method3"

    on "m1", "foo#method2" # this should not be reachable
    on "some/:id", "bar#some"
  end
end

def routes1
  Spec1::Sample1.new
end

describe Routing::BasicRouter do
  it "should build routes" do
    routes1.should_not be_nil
  end

  it "should exec route" do
    routes1.route("m1").should eq(1)
    routes1.route("m2").should eq(2)
    routes1.route("m3").should eq("3")
  end

  it "should get params from route part" do
    routes1.route("some/42").should eq("42")
  end
end
