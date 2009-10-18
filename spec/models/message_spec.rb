require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do
  before(:each) do
    @valid_attributes = {
      :data => "value for data",
      :gate_name => "test_gate"
    }
  end

  it "should create a new instance given valid attributes" do
    Message.create!(@valid_attributes)
  end 
  
  describe "processing gates" do
    
    def mock_gate
      @mock_gate ||= mock("Gate")
    end
    
    before(:each) do
      @message = Message.create!(@valid_attributes)
      Gate.stub!(:registered_gates).and_return({:test_gate => mock_gate})
      Gate.should_receive(:registered_gates).with no_args
    end
    
    it "should find the gate it belongs to" do
      @message.gate.should equal(mock_gate)
    end
    
    # it "should deliver itself through its gate" do
    #       @message.deliver
    #     end
    
  end
  
end
