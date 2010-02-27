require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do
  before(:each) do
    gate :test_gate
    @valid_attributes = {
      :data => {:message => "message"},
      :gate_name => "test_gate"
    }
  end
  
  def mock_gate
    @mock_gate ||= mock("Gate", :process => true, :deliver => true, :queue? => false)
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
      m = Message.new(@valid_attributes)
      m.push!
      m.should be_in_queue
    end
    
    it "should avoid saving while pushing if specified" do
      m = Message.new(@valid_attributes)
      m.push!(:dont_save => true)
      m.should be_new_record
    end
  end
  
  describe "while saving" do
    it "should verify gate type" do
      m = Message.new(@valid_attributes)
      m.stub!(:gate).and_return(mock_gate)
      m.should_receive(:gate)
      m.save
    end
    
    describe "normal gate delivery" do
      it "should call send_later to delay the job after saving for gates that are not queued" do
        m = Message.new(@valid_attributes)
        m.should_receive(:send_later).with(:deliver!)
        m.save
      end
    end
        
    describe "message queue gate delivery" do
      before(:each) do
        gate :test_gate, :queue => true
      end

      it "should save messages with the in_queue property on" do
        m = Message.new(@valid_attributes)
        m.should_receive(:push!)
        m.save
      end
      
      it "should delay the processing of messages that have queue" do
        process("sample") { |test| discard }
        m = Message.new(@valid_attributes)
        m.should_receive(:send_later).with(:deliver!)
        m.save
      end
      
      it "should save messages as queued if they have no process pending" do
        m = Message.new(@valid_attributes)
        m.save
        m.should be_in_queue
      end
      
      it "should not save messages as queued if they have pending processing" do
        process("sample") { |test| discard }
        m = Message.new(@valid_attributes)
        m.save
        m.should_not be_in_queue
      end
    end
  end
  
  describe "processing gates" do 
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
  
  describe "queue support" do
    it "should pop one element from the queue" do
      m = Message.create(@valid_attributes)
      m.push!
      
      Message.pop!("test_gate").id.should == m.id
    end
    
    it "should record the measurement of the popped message" do
      m = Message.create(@valid_attributes)
      m.push!
      Measurement.should_receive(:record)
      
      Message.pop!("test_gate")
    end
    
    it "should pop the first element pushed" do
      m1 = Message.create!(@valid_attributes)
      m1.push!
      m2 = Message.create!(@valid_attributes)
      m2.push!
      
      Message.pop!("test_gate").id.should == m1.id
      Message.pop!("test_gate").id.should == m2.id
    end
    
    it "should return nil if the queue is empty" do
      Message.pop!("test_gate").should be_nil
    end
    
    it "should only return messages of the correct queue type" do
      gate :another_one
      m2 = Message.create(:gate_name => "another_one", :data => {:field => "data"})
      m2.push!
      m1 = Message.create!(@valid_attributes)
      m1.push!
      
      
      Message.pop!("test_gate").id.should == m1.id
      Message.pop!("test_gate").should be_nil
      Message.pop!("another_one").id.should == m2.id
      Message.pop!("another_one").should be_nil
    end
  end
end
