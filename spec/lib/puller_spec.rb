require File.dirname(__FILE__) + '/../spec_helper'

describe Puller do
  before(:each) do
    Gate.registered_gates.clear
    Puller.instance.clear
  end
  
  def create_sample_gate
    gate :sample
    pull :from => "http://www.google.com/resources"
  end

  it "should be a singleton" do
    lambda {Puller.new}.should raise_error
    Puller.instance.should be_kind_of(Puller)
  end
  
  it "should collect the pulls from the gates" do
    create_sample_gate
    Puller.instance.pulls.length.should == 1
  end
  
  describe "running the process" do
    before(:each) do
      create_sample_gate
      @pull = Puller.instance.pulls.first
      Puller.stub!(:sleep).and_return true
      sample_pull.http_source.stub!(:find).and_return []
    end
    
    def sample_pull
      @pull
    end
    
    it "should provide a way to call a block once messages are received from a source" do
      lambda do
        Puller.start do |source, count| 
          "#{count} new #{count > 1 ? "message".pluralize : "message"} received."
          break
        end
      end.should_not raise_error
    end
        
    it "should start a thread for each configured pull" do
      Puller.should_receive(:run).with(sample_pull, nil)
      Puller.start
    end
    
    it "should sleep the interval" do
      sample_pull.should_receive(:interval).and_return(300)
      Puller.should_receive(:sleep).with(300).and_return(true)
      
      counter = 0
      break_block = Proc.new do |source, count| 
        counter += 1
        Thread.exit if counter == 2
      end
      lambda {Puller.run(sample_pull, break_block)}.should raise_error(SystemExit)
    end
    
    it "should check if the pull is a custom pull" do
      sample_pull.should_receive(:custom_pull).and_return(nil)
      
      break_block = Proc.new { |source, count| Thread.exit }
      lambda {Puller.run(sample_pull, break_block)}.should raise_error(SystemExit)
    end
    
    it "should consider parameterless custom pulls as not asking for an ActiveResource class" do
      mock_proc = mock("Proc", :call => [], :arity => 0)
      mock_proc.should_receive(:call).with no_args
      sample_pull.custom_pull = mock_proc
      
      break_block = Proc.new { |source, count| Thread.exit }
      lambda {Puller.run(sample_pull, break_block)}.should raise_error(SystemExit)
    end
    
    it "should consider custom pulls with one parameter as asking for an ActiveResouce class" do
      mock_proc = mock("Proc", :call => [], :arity => 1)
      mock_proc.should_receive(:call).with(sample_pull.http_source)
      sample_pull.custom_pull = mock_proc
      
      break_block = Proc.new { |source, count| Thread.exit }
      lambda {Puller.run(sample_pull, break_block)}.should raise_error(SystemExit)
    end
    
    it "should call 'all' on the ActiveResource class if no custom block is provided" do
      sample_pull.http_source.should_receive(:find).with(:all).and_return([])
      
      break_block = Proc.new { |source, count| Thread.exit }
      lambda {Puller.run(sample_pull, break_block)}.should raise_error(SystemExit)
    end 
  end
  
end