require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gate do
  before(:each) do
    @gate = Gate.new :test
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
    
    it "should have an empty list of pulls" do
      @gate.pulls.should be_empty
    end
    
    it "should by default use starling" do
      @gate.should_not be_guaranteed
    end
  end
  
  describe "configured and initialized" do
    before(:each) do
      @gate.processing_list["test"] = lambda { |data| data[:some] == "value" }
      @gate.receivers << "http://example.com/test"
    end
    
    def mock_ar(stubs={})
      @ar ||= mock("ActiveResource::Base", stubs.merge!({:save => true}))
    end
    
    def mock_delivery(stubs={})
      @delivery ||= mock(Http::Delivery, stubs.merge!({:data= => {}, :deliver => true}))
    end
    
    it "should provide a way to look for existing gates by name" do
      Gate.find("test").should_not be_nil
    end
    
    
    describe "processing messages" do
      it "should be able to process messages through the gate" do
        @gate.process mock_message
      end

      it "should set the processing message as the current message" do
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
    end
    
    describe "delivering messages" do
      it "should not deliver discarded messages" do
        m = mock_message(:discarded? => true)
        m.should_receive(:discarded?).and_return(true)
        @gate.should_not_receive(:deliver_to_receivers)
        @gate.deliver m
      end
      
      it "should figure out if it's delivering through ActiveResource of through a message queue" do
        m = mock_message(:save => true, :push! => true)
        m.should_receive(:push!).and_return(true)
        
        g = Gate.new :queued, :queue => true
        g.should_not_receive(:deliver_to_receivers)
        g.deliver m
      end
      
      describe "delivering to one or more receivers" do
        it "should be able to deliver message to receivers" do
          Http::Delivery.stub!(:new).and_return(mock_delivery)
          @gate.deliver_to_receivers mock_message
        end

        it "should raise an error if no receivers are defined" do
          @gate.receivers.clear
          lambda {@gate.deliver_to_receivers(mock_message)}.should raise_error
        end
      end
    end
  end
  
end