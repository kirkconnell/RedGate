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
  
  describe "configuring pulling sources" do
    it "should store pull objects in the gate structure" do
      g = gate(:name)
      pull :from => "http://www.google.com/resources/"
      g.pulls.first.should be_kind_of Http::Pull
    end
    
    it "should allow the definition of a single pull source" do
      g = gate(:name)
      pull :from => "http://www.google.com/resources/"
      g.pulls.length.should == 1
    end
    
    it "should allow the definition of various pull sources" do
      g = gate(:name)
      pull :from => ["http://www.source1.com/resources/", "http://www.source2.com/resources/"]
      g.pulls.length.should == 2
    end
    
    it "should allow the definition of pulls with custome algorithm" do
      g = gate(:name)
      pull(:from => "http://www.google.com/resources/") { true }
      g.pulls.first.custom_pull.should_not be_nil
    end
  end
    
  describe "message queue configuration" do
    it "should accept parameters for creating a message queue" do
      gate(:name, :queue => true).should be_queue
    end
    
    it "should not allow the configuration of one receiver" do
      gate(:name, :queue => true)
      lambda { receiver "http://www.google.com" }.should raise_error
    end
    
    it "should not allow the configuration of receivers" do
      gate(:name, :queue => true)
      lambda { receivers "http://www.google.com" }.should raise_error
    end
  end
  
  describe "guaranteed channel configuration" do
    it "should accept parameters for creating a guaranteed channel" do
      gate(:name, :guaranteed => true).should be_guaranteed
    end
  end
    
end

describe GateBuilder::Initializer do
  it "should run the gate initialization process" do
    GateBuilder::Initializer.run { "test" }.should == "test"
  end
end
