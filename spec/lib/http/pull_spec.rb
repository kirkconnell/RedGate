require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Http::Pull do
  describe "configuration" do
    it "should require a source to pull from" do
      lambda {Http::Pull.new}.should raise_error
      lambda {Http::Pull.new :gate => :sample, :from => "http://www.restgate.com/sample" }.should_not raise_error
    end

    it "should allow an interval to pull from" do
      puller = Http::Pull.new(:gate => :sample, :from => "http://test.test.com/sample/", :interval => 20)
      puller.interval.should == 20
    end
  end
  
  
  it "should create an ActiveRecord class to retrieve values" do
    puller = Http::Pull.new(:gate => :sample, :from => "http://test.test.com/sample")
    puller.http_source.superclass == ActiveResource::Base
  end
end