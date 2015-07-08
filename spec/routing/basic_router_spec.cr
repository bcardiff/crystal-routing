require "./../spec_helper"

class Foo
  def method1
    1
  end

  def method2
    2
  end
end

class Bar
  def method3
    "3"
  end
end

module Spec1
  basic_router Sample1 do
    on "m1", "foo#method1"
    on "m2", "foo#method2"
    on "m3", "bar#method3"
  end
end

describe Routing::BasicRouter do
  it "should build routes" do
    Spec1::Sample1.new
  end

  it "should exec route" do
    Spec1::Sample1.new.route("m1").should eq(1)
    Spec1::Sample1.new.route("m2").should eq(2)
    Spec1::Sample1.new.route("m3").should eq("3")
  end
end
