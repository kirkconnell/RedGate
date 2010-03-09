require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GatesController do
  
  def mock_message_hash
    @message_hash ||=  { :first => "first", :second => "second" }
  end
  
  def mock_message(stubs = {})
    @message ||= mock_model(Message, stubs)
  end
  
  describe "receiving messages" do
    before(:each) do
      gate :test
      receiver "http://www.example.com/sample"
      MessageWorker.stub!(:asynch_deliver).and_return(true)
    end
    
    it "should reject posts to unexisting gates" do
      post :receive, :gate_name => "non_existing"
      assigns(:error).should_not be_nil
    end
    
    it "should accept posts to existing gates" do
      post :receive, :gate_name => "test", :message => mock_message_hash
      response.should be_success
    end
    
    it "should consider hash parameters as message in a post request" do
      # This is because ActiveResource will send the post as a hash, 
      # which will contain another hash inside with the message.
      post :receive, :gate_name => "test", :message => mock_message_hash
      assigns(:message).data[:first].should == "first"
      assigns(:message).data[:second].should == "second"
    end
    
    it "should save the message to the database" do
      Message.stub!(:new).and_return(
        mock_message({:data => mock_message_hash, 
                      :gate_name => :test, 
                      :save => true, 
                      :send_later => true}))     
      post :receive, :gate_name => "test", :message => mock_message_hash
      response.should be_success
    end
    
    it "should not save invalid messages to the database" do
      Message.stub!(:new).and_return(
        mock_message({:data => mock_message_hash, 
                      :gate_name => :test, 
                      :save => false}))     
      post :receive, :gate_name => "test", :message => mock_message_hash
      assigns(:error).should_not be_nil
    end    
  end
  
  describe "handling queued messages" do
    before(:each) do
      gate :test, :queue => true
    end
    
    it "should reject unexisting gate retrieval requests" do
      get :retrieve, :gate_name => "apples"
      assigns(:error).should_not be_nil
    end
    
    it "should get latest message from queue" do
      m = Message.create!(:gate_name => "test", :data => mock_message_hash)
      m.push!
      
      get :retrieve, :gate_name => "test"
      assigns(:message).id.should == m.id
    end
    
    it "should render the message data" do
      msg = mock_message(:data => mock_message_hash, :gate_name => "test")
      Message.stub!(:pop!).and_return(msg)
      msg.should_receive :data

      get :retrieve, :gate_name => "test"
    end
    
    it "should not crash if there's nothing on the queue" do
      get :retrieve, :gate_name => "test"
      assigns(:error).should be_nil
      assigns(:message).should be_nil
    end
  end
end
