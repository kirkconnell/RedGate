require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
  it "should recognize gate URIs" do
    gate_path("test_gate").should == "/gates/test_gate"
  end
end