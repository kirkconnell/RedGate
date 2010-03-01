require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class TestActiveResourceGenerator
  include Http::ActiveResourceGenerator
end

describe Http::ActiveResourceGenerator do
  before(:each) do
    @generator = TestActiveResourceGenerator.new
    @generator.initialize_type_store(:host => 'http://test.example.com/', :element => 'test', :gate => :sample)
  end
  
  def mock_ar(stubs = {})
    mock("ActiveResource", stubs)
  end
  
  describe "initializing" do
    it "should validate that gate is required" do
      lambda {@generator.initialize_type_store(:host => 'http://test.example.com/', 
        :element => 'test')}.should raise_error
    end
  end
  
  describe "creating ActiveResource class" do
    it "should generate instructions for ActiveResource reflection" do
      @generator.instructions.should == "self.site = 'http://test.example.com/'; self.element_name = 'test';"
    end

    it "should name ActiveResource reflection according to the gate name" do
      @generator.ar_class_name.should == "Test"
    end

    it "should create an ActiveResource class based on the receiver" do
      @generator.generate_type
      @generator.stored_type.superclass.should == ActiveResource::Base
    end
    
    it "should only create the type once" do
      @generator.generate_type
      @generator.should_not_receive(:store)
      @generator.generate_type
    end
  end
end