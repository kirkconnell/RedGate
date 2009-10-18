require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GateBuilder do
  
  before(:each) do
    Gate.registered_gates.clear
  end
  
  describe "defining a gate" do    
    it "receives a symbol with the name of the gate" do
      gate(:name).should be_instance_of(Gate)
    end
    
    it "stores the gate object in the list of registerd gates" do
      g = gate(:name)
      Gate.currently_configuring.should equal(g)
    end
    
    it "defines a process for the gate created" do
      gate(:name)      
      process("testing process") { |data| data }
      
      Gate.currently_configuring.processing_list.should be_include("testing process")
    end
    
    it "defines a receiver for a gate's messages" do
      g = gate(:name)
      receiver "http://www.google.com"
      
      g.receivers.should be_include("http://www.google.com")
    end
    
  end
end

describe GateBuilder::Initializer do
  it "should run the initialization of the gate mechanism" do
    GateBuilder::Initializer.run { "test" }.should == "test"
  end
end
