require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hash do
  it "should add a method for every key value" do
    h = {}
    h[:sample] = "sample"
    h.sample.should == "sample"
  end
  
  it "should not add methods for keys that are not in the hash" do
    h = {}
    h[:another_example] = "sample"
    lambda{ h.sample }.should raise_error
  end
  
  it "should allow to modify values of keys by method" do
    h = {}
    h[:sample] = "sample"
    h.sample = "new value"
    h.sample.should == "new value"
  end
  
  it "should define new keys using key= method" do
    h = {}
    h.sample = "sample"
    h[:sample].should == "sample"
  end
  
end