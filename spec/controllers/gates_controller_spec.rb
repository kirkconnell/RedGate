require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GatesController do
  
  describe "receiving messages" do
    before(:each) do
      gate :test
      receiver "http://www.example.com/sample"
    end
    
    def mock_message_hash
      @message_hash ||=  { :first => "first", :second => "second" }
    end
    
    def mock_message(stubs = {})
      @message ||= mock_model(Message, stubs)
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
    
    it "should enqueue the message for processing" do
      Message.stub!(:new).and_return(
        mock_message({:data => mock_message_hash, 
                      :gate_name => :test, 
                      :save => true, 
                      :send_later => true}))
      mock_message.should_receive(:send_later).with(:deliver!).and_return(true)
      post :receive, :gate_name => "test", :message => mock_message_hash
    end
    
  end

  # describe "dealing with message retrieval requests" do
  #     it "should reject unexisting gate retrieval requests" do
  #       get :retrieve, :gate_name => "apples"
  #       assigns(:error).should_not be_nil
  #     end
  #   end
end
