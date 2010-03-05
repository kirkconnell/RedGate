require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Http::Pull do
  describe "configuration" do
    it "should require a source to pull from" do
      lambda {Http::Pull.new}.should raise_error
      Http::Pull.new :gate => :sample, :from => "http://www.restgate.com/sample"
    end

    it "should allow an interval to pull from" do
      pull = Http::Pull.new(:gate => :sample, :from => "http://test.test.com/sample/", :interval => 20)
      pull.interval.should == 20
    end
    
    it "should provide the gate name" do
      pull = Http::Pull.new(:gate => :sample, :from => "http://www.restgate.com/sample")
      pull.gate_name.should == :sample
    end
    
    it "should store a block for custom pulls" do
      pull = Http::Pull.new :gate => :sample, :from => "http://www.restgate.com/sample"
      pull.custom_pull = lambda { true }
      pull.custom_pull.call.should == true
    end
  end
  
  describe "working" do
    it "should provide the URI of the resource for instrumentation" do
      pull = Http::Pull.new :gate => :sample, :from => "http://www.restgate.com/sample"
      pull.uri.should == "http://www.restgate.com/sample"
    end
    
    it "should create an ActiveRecord class to retrieve values" do
      pull = Http::Pull.new(:gate => :sample, :from => "http://test.test.com/sample")
      pull.http_source.superclass == ActiveResource::Base
    end
  end
end