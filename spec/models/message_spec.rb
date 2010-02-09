require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do
  before(:each) do
    @valid_attributes = {
      :data => "value for data",
      :gate_name => "test_gate"
    }
  end

  describe "management activities" do
    it "should create a new instance given valid attributes" do
      Message.create!(@valid_attributes)
    end
    
    it "should store the float value of the current time it was received" do
      moment = Time.now
      Time.stub!(:now).and_return(moment)
      m = Message.create!(@valid_attributes)
      m.exactly_received_at.should == moment.to_f
    end
    
    it "should provide access to the current message" do
      Message.current = @message
      Message.current.should == @message
    end
    
    it "should identify itself as in a queue" do
      m = Message.new
      m.in_queue = true
      m.should be_valid
    end
  end
   
  
  describe "processing gates" do 
    def mock_gate
      @mock_gate ||= mock("Gate", :process => true, :deliver => true)
    end
    
    before(:each) do
      @message = Message.create!(@valid_attributes)
      Gate.stub!(:registered_gates).and_return({:test_gate => mock_gate})
      Gate.should_receive(:registered_gates).with no_args
    end
    
    it "should find the gate it belongs to" do
      @message.gate.should equal(mock_gate)
    end
    
    it "should deliver itself through its gate" do
      mock_gate.should_receive(:process).with(@message)
      @message.deliver!
    end
    
    it "should record a measurement for the operation" do
      Measurement.should_receive(:record).with(@message)
      @message.deliver!
    end
  end
  
end
