require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Delivery::HttpDelivery do
  
  def mock_ar(stubs = {})
    mock("ActiveResource", stubs)
  end
  
  before(:each) do
    @http = Delivery::HttpDelivery.new(:gate => :sample, :uri => "http://test.example.com/tests")
  end
  
  describe "creating ActiveResource class" do
    it "should generate instructions for ActiveResource reflection" do
      @http.instructions.should == "self.site = 'http://test.example.com/'; self.element_name = 'test';"
    end

    it "should name ActiveResource reflection according to the gate name" do
      @http.ar_class_name.should == "SampleDelivery"
    end

    it "should create an ActiveResource class based on the receiver" do
      data = {:first => "information"}
      @http.load_with(data).should be_kind_of(ActiveResource::Base)
    end
  end
  
  describe "reusing the already created ActiveResource classes" do
    it "should store the manufactured class delivered to reuse it later on" do
      host = "http://test.example.com/"
      data = {:some_field => "stuff that I'm sending"}
      @http.load_with(data)
      @http.stored_type_for(:sample, host).new.should be_kind_of(ActiveResource::Base)
    end

    it "should look on the stored types before creating one of their own" do
      data = {:some_field => "stuff that I'm sending"}
      @http.should_receive(:stored_type_for).with(:sample, "http://test.example.com/").and_return(nil)
      @http.load_with(data)
    end

    it "should create ActiveResource object from the stored type if one exists" do
      data = {:some_field => "stuff that I'm sending"}
      @http.should_receive(:stored_type_for).twice.with(:sample,
                            "http://test.example.com/").and_return(mock_ar.class)

      @http.load_with(data)
    end
  end
  
  describe "doing the actual work" do
    it "should post the ActiveResource object to the receiver" do
      @http.ar = mock_ar(:save => true)
      @http.ar.should_receive(:save).and_return(:true)

      @http.deliver
    end
  end
  
  describe "parsing delivery uri's" do
    it "should create options based on the receiver" do
      sample_options = { :host => "http://example.com/", :element => "folk"}
      @http.extract_options_from("http://example.com/folks/").should == sample_options
    end

    it "should complain if the receiver uri is malformed" do
      lambda {@http.extract_options_from("htp://example.com")}.should raise_error
    end

    it "should allow https uris" do
      lambda {@http.extract_options_from("https://example.com/secure/")}.should_not raise_error
    end

    it "should allow uris without the trailing /" do
      lambda {@http.extract_options_from("http://example.com/forgot")}.should_not raise_error
    end
  end
  
end