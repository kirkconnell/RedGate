require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gate do
  before(:each) do
    @gate = Gate.new :test
  end
  
  describe "freshly created" do
    it "should register created gates on a list" do
      Gate.registered_gates[:test].should equal(@gate)
    end
    
    it "should be saved as the current configuration gate" do
      Gate.currently_configuring.should equal(@gate)
    end
    
    it "should have an empty list of blocks to execute on processing" do
      @gate.processing_list.should be_empty
    end
    
    it "should have an empty list of receivers" do
      @gate.receivers.should be_empty
    end
  end
  
end