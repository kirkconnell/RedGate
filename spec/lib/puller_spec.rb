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
      Puller.stub!(:sleep).and_return true
      sample_pull.http_source.stub!(:find).and_return []
    end
    
    def sample_pull
      @pull ||= Puller.instance.pulls.first
    end
        
    it "should start a thread for each configured pull" do
      mock_thread = mock(Thread, :join => true)
      Thread.should_receive(:start).and_return(mock_thread)
      Puller.start
    end
    
    describe "pulling messages from a source" do
      it "should check if the pull is a custom pull" do
        sample_pull.should_receive(:custom_pull).and_return(nil)
        Puller.pull_messages(sample_pull)
      end

      it "should consider parameterless custom pulls as not asking for an ActiveResource class" do
        mock_proc = mock("Proc", :call => [], :arity => 0)
        mock_proc.should_receive(:call).with no_args
        sample_pull.custom_pull = mock_proc
        Puller.pull_messages(sample_pull)
      end

      it "should consider custom pulls with one parameter as asking for an ActiveResouce class" do
        mock_proc = mock("Proc", :call => [], :arity => 1)
        mock_proc.should_receive(:call).with(sample_pull.http_source)
        sample_pull.custom_pull = mock_proc
        Puller.pull_messages(sample_pull)
      end

      it "should call 'all' on the ActiveResource class if no custom block is provided" do
        sample_pull.http_source.should_receive(:find).with(:all).and_return([])
        Puller.pull_messages(sample_pull)
      end
    end
    
    describe "after receiving one or more messages" do
      before(:each) do
        Puller.stub!(:pull_messages).and_return [mock_msg]
        
      end
      
      def mock_msg
        @mock_msg ||= mock(Message, :attributes => {})
      end
      
      it "should provide a way to call an informative callback when messages are received from a source" do
        counter = 0
        proc = Proc.new { |source, count| counter += count }
        Puller.iterate sample_pull, proc
        counter.should == 1
      end

      it "should process the resources as messages" do
        Message.should_receive(:create!).with(:data => mock_msg.attributes, :gate_name => "sample")
        Puller.iterate sample_pull
      end
    end
  end
end