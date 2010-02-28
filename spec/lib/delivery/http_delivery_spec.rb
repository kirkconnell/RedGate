require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Delivery::HttpDelivery do
  
  def mock_ar(stubs = {})
    mock("ActiveResource", stubs)
  end
  
  before(:each) do
    @strat = Delivery::HttpDelivery.new(:host => "http://test.example.com/", 
                                                          :element => "test", :gate => :sample)
  end
  
  it "should generate instructions for ActiveResource reflection" do
    @strat.instructions.should == "self.site = 'http://test.example.com/'; self.element_name = 'test';"
  end
  
  it "should name ActiveResource reflection according to the gate name" do
    @strat.ar_class_name.should == "SampleDelivery"
  end
  
  it "should create an ActiveResource object based on the receiver" do
    data = {:first => "information"}
    @strat.load_with(data).should be_kind_of(ActiveResource::Base)
  end
  
  it "should store the manufactured delivered to reuse it later on" do
    host = "http://test.example.com/"
    data = {:some_field => "stuff that I'm sending"}
    @strat.load_with(data)
    @strat.stored_type_for(:sample, host).new.should be_kind_of(ActiveResource::Base)
  end
  
  it "should look on the stored types before creating one of their own" do
    data = {:some_field => "stuff that I'm sending"}
    @strat.should_receive(:stored_type_for).with(:sample, "http://test.example.com/").and_return(nil)
    @strat.load_with(data)
  end
  
  it "should create ActiveResource object from the stored type if one exists" do
    data = {:some_field => "stuff that I'm sending"}
    @strat.should_receive(:stored_type_for).twice.with(:sample,
                          "http://test.example.com/").and_return(mock_ar.class)
                          
    @strat.load_with(data)
  end
  
  it "should post the ActiveResource object to the receiver" do
    @strat.ar = mock_ar(:save => true)
    @strat.ar.should_receive(:save).and_return(:true)
    
    @strat.deliver
  end
  
end