require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
  it "should recognize queue URIs" do
    queue_path("test_gate").should == "/test_gate/pop"
  end
  
  it "should recognize dropbox URIs" do
    dropbox_path("sample").should == "/sample"
  end  
end