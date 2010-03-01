require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class TestURIAnalizer
  include Http::URIAnalizer
end

describe Http::URIAnalizer do
  def analizer
    @analizer ||= TestURIAnalizer.new
  end
  
  describe "parsing uri's" do
    it "should create options based on the receiver" do
      sample_options = { :host => "http://example.com/", :element => "folk"}
      analizer.extract_options_from("http://example.com/folks/").should == sample_options
    end

    it "should complain if the receiver uri is malformed" do
      lambda {analizer.extract_options_from("htp://example.com")}.should raise_error
    end

    it "should allow https uris" do
      lambda {analizer.extract_options_from("https://example.com/secure/")}.should_not raise_error
    end

    it "should allow uris without the trailing /" do
      lambda {analizer.extract_options_from("http://example.com/forgot")}.should_not raise_error
    end
  end
end