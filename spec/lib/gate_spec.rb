require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gate do
  before(:each) do
    @gate = Gate.new :test
    Gate.register @gate
  end
  
  it "should provide a way to look for existing gates by name" do
    Gate.find("test").should_not be_nil
  end
  
  describe "freshly created" do
    it "should register created gates on a list" do
      Gate.registered_gates[:test].should equal(@gate)
    end
    
    it "should be saved as the current configuration gate" do
      Gate.currently_configuring.should equal(@gate)
    end
    
    it "should have an empty list of blocks to execute on processing" do
      @gate.processing_list.should be_empty
    end
    
    it "should have an empty list of receivers" do
      @gate.receivers.should be_empty
    end
  end
  
  describe "loaded" do
    before(:each) do
      @gate.processing_list["test"] = lambda { |data| data[:some] == "value" }
      @gate.receivers << "http://example.com/test"
    end
    
    def mock_message(stubs = {})
      @message ||= mock_model(Message, stubs.merge!({ :data => { :some => "value" } }))
    end
    
    def mock_ar(stubs={})
      @ar ||= mock("ActiveResource::Base", stubs.merge!({:save => true}))
    end
    
    def mock_strategy(stubs={})
      @strategy ||= mock(DeliveryStrategy, stubs.merge!({:load_with => true, :deliver => true}))
    end
    
    it "should be able to process messages through the gate" do
      @gate.process mock_message
    end
    
    it "should deliver message to receivers" do
      DeliveryStrategy.stub!(:for).and_return(mock_strategy)
      @gate.deliver_to_receivers mock_message
    end
    
    it "should not raise an error if no receivers are defined" do
      @gate.receivers.clear
      lambda {@gate.deliver_to_receivers(mock_message)}.should raise_error
    end
    
  end
  
end