require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gate do
  it "should exist" do
    Gate.new.should be_instance_of(Gate)
  end
end