require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Measurement do
  before(:each) do
    @valid_attributes = {
      :gate_name => "value for gate_name",
      :message_id => 1,
      :sent_at => Time.now
    }
  end
  
  def message(stubs = {})
    @message ||= mock_model(Message, {:id => 1, :gate_name => :gate}.merge(stubs))
  end
  
  def measurement
    @measurement ||= Measurement.new
  end

  it "should create a new instance given valid attributes" do
    Measurement.create!(@valid_attributes)
  end
  
  it "should record measurement for gate" do
    sample_date = DateTime.now
    DateTime.stub!(:now).and_return(sample_date)
    Measurement.should_receive(:create!).with(:message_id => message.id, 
                                              :gate_name => message.gate_name,
                                              :sent_at => sample_date)
    Measurement.record message
  end
  
  it "should calculate the received date" do
    arrival_time = 10.minutes.ago
    message :created_at => arrival_time
    measurement.message = message
    measurement.received_at.should == arrival_time
  end
  
  it "should calculate the time interval between message arrival and message departure" do
    arrival_time = 10.minutes.ago
    measurement.stub!(:sent_at => arrival_time + 10.minutes)
    
    message :created_at => arrival_time
    measurement.message = message
    measurement.interval.should == 10.minutes
  end
  
end
