require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Delivery::ActiveResourceDeliveryStrategy do
  
  def mock_ar(stubs = {})
    mock("ActiveResource", stubs)
  end
  
  before(:each) do
    @strat = Delivery::ActiveResourceDeliveryStrategy.new(:host => "http://test.example.com/", :element => "test")
  end
  
  it "should generate instructions" do
    @strat.instructions.should == "self.site = 'http://test.example.com/'; self.element_name = 'test';"
  end
  
  it "should create an active resource object based on the receiver" do
    data = {:first => "information"}
    @strat.load_with(data).should be_kind_of(ActiveResource::Base)
  end
  
  it "should post the active resource object to the receiver" do
    @strat.ar = mock_ar(:save => true)
    @strat.ar.should_receive(:save).and_return(:true)
    
    @strat.deliver
  end
  
end