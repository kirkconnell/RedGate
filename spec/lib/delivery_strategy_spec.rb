require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DeliveryStrategy do
  it "should create options based on the receiver" do
    sample_options = { :host => "http://example.com/", :element => "folk" }
    DeliveryStrategy.options_for("http://example.com/folks/").should == sample_options
  end
  
  it "should allow https uris" do
    DeliveryStrategy.for "https://example.com/secure/"
  end
  
  it "should allow uris without the trailing /" do
    DeliveryStrategy.for "http://example.com/forgot"
  end
  
  it "should complain if the receiver uri is malformed" do
    lambda {DeliveryStrategy.options_for("htp://example.com")}.should raise_error
  end
  
  it "should return an ActiveResourceDeliveryStrategy if it receives a uri" do
    DeliveryStrategy.for("http://example.com/folks/").should be_kind_of(Delivery::ActiveResourceDeliveryStrategy)
  end
  
end