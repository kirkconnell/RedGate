require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GatesController do
  
  describe "receiving messages" do
    it "should reject posts to unexisting gates" do
      post :receive, :gate_name => "apples"
      assigns(:error).should_not be_nil
    end
    
    # This is because ActiveResource will send the post as a hash which will contain
    # another hash inside with the data. 
    # it "should consider hash parameters as message in a post request" do
    #       data = { :first => "first", :second => "second" }
    #       post :receive, :gate_name => "apples", :data => data
    #       assigns(:message).to_s.should be_eql(data.to_s)
    #     end
    
  end

  describe "dealing with message retrieval requests" do
    it "should reject unexisting gate retrieval requests" do
      get :retrieve, :gate_name => "apples"
      assigns(:error).should_not be_nil
    end
  end
end
