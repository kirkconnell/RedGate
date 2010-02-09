require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gate do
  before(:each) do
    @gate = Gate.new :test
    Gate.register @gate
  end
  
  describe "during configuration process" do
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
  
  describe "configured and initialized" do
    before(:each) do
      @gate.processing_list["test"] = lambda { |data| data[:some] == "value" }
      @gate.receivers << "http://example.com/test"
    end
    
    it "should provide a way to look for existing gates by name" do
      Gate.find("test").should_not be_nil
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
    
    it "should raise an error if no receivers are defined" do
      @gate.receivers.clear
      lambda {@gate.deliver_to_receivers(mock_message)}.should raise_error
    end
    
    it "should provide a way of getting a reference to the current message" do
      Message.should_receive(:current=).and_return(mock_message)
      @gate.process mock_message
    end
    
    it "should allow messages to be discarded when running a process" do
      @gate.processing_list.clear
      @gate.processing_list["discarding"] = lambda { |data| discard }
      mock_message.should_receive(:discard!)
      @gate.process mock_message
    end
    
    it "should not processes discarded messages" do
      m = mock_message(:discarded? => true)
      m.should_receive(:discarded?).and_return(true)
      @gate.should_not_receive(:processing_list)
      @gate.process m
    end
    
    it "should check if the message is discarded after every processing" do
      m = mock_message
      m.should_receive(:discarded?).twice.and_return(false)
      @gate.process m
    end
    
    it "should not deliver discarded messages" do
      m = mock_message(:discarded? => true)
      m.should_receive(:discarded?).and_return(true)
      @gate.should_not_receive(:receivers)
      @gate.deliver_to_receivers m
    end
    
  end
  
end