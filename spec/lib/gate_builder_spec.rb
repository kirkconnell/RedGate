require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GateBuilder do
  
  before(:each) do
    Gate.registered_gates.clear
  end
  
  it "should receive a symbol with the name of the gate" do
    gate(:name).should be_instance_of(Gate)
  end
  
  it "should store the gate object in the list of registerd gates" do
    g = gate(:name)
    Gate.currently_configuring.should equal(g)
  end
  
  it "should define one or more processes for the gate been configured" do
    gate(:name)      
    process("testing process") { |data| data }
    
    Gate.currently_configuring.processing_list.should be_include("testing process")
  end
  
  it "should define one receiver for a gate's messages" do
    g = gate(:name)
    receiver "http://www.google.com"
    
    g.receivers.should be_include("http://www.google.com")
  end
  
  it "should define multiple receivers for a gate's messages" do
    g = gate(:name)
    receivers "http://www.google.com", "http://www.yahoo.com"
    
    g.receivers.should be_include("http://www.google.com")
    g.receivers.should be_include("http://www.yahoo.com")
  end
    
end

describe GateBuilder::Initializer do
  it "should run the gate initialization process" do
    GateBuilder::Initializer.run { "test" }.should == "test"
  end
end
