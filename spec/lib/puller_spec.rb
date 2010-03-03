require File.dirname(__FILE__) + '/../spec_helper'

describe Puller do
  before(:each) do
    Gate.registered_gates.clear
    gate :sample
    pull :from => "http://www.google.com/resources"
  end

  it "should be a singleton" do
    lambda {Puller.new}.should raise_error
    Puller.instance.should be_kind_of(Puller)
  end
  
  it "should collect the pulls from the gates" do
    Puller.instance.pulls.length.should == 1
  end
end