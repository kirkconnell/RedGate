require 'spec_helper'

describe GateGeneratorHelper do
  class TestHelper
    include GateGeneratorHelper
  end
  
  let(:helper) { TestHelper.new }
  
  context "parsing arguments" do   
    context "for process definition" do
      it "should have an empty list of processes when no processing option is given" do
        helper.parse []
        helper.processes.should be_empty
      end
      
      it "should have a processor in the process list when the process option is given" do
        helper.parse %w{processor}
        helper.processes.length.should == 1
        helper.processes.first.should == :processor
      end
      
      it "should have a filter in the process list when the filter option is given" do
        helper.parse %w{processor filter}
        helper.processes.should be_include :filter
      end
      
      it "should have a router in the process list when the router option is given" do
        helper.parse %w{processor filter router}
        helper.processes.should be_include :router
      end
      
      it "should have a splitter in the process list when the splitter option is given" do
        helper.parse %w{splitter}
        helper.processes.should be_include :splitter
      end
    end
    
  end
  
  context "rendering" do
    before(:each) do
      helper.stub!(:file_name).and_return "samples"
    end
    
    context "gate defininition" do
      it "should render simple gate definitions" do
        helper.parse []
        helper.render(:gate_definition).should == "gate :samples"
      end
      
      it "should render queue gate definitions" do
        helper.parse %w{queue}
        helper.render(:gate_definition).should == "gate :samples, :queue => true"
      end
      
      it "should render guaranteed gate definitions" do
        helper.parse %w{guaranteed}
        helper.render(:gate_definition).should == "gate :samples, :guaranteed => true"
      end
    end
    
    context "receiver commands" do
      it "should generate a receivers command" do
        helper.parse %w{uri1 uri2}
        helper.render(:receivers).should == "receivers 'uri1', 'uri2'"
      end
    
      it "should generate a receiver command if only one receiver is in the arguments" do
        helper.parse %w{uri}
        helper.render(:receivers).should == "receiver 'uri'"
      end
    
      it "should render nothing if no receivers are defined" do
        helper.parse []
        helper.render(:receivers).should be_nil
      end
    end
    
    context "process commands" do
      it "should generate a process block" do
        helper.render(:process => :processor).should == 
"process \"sample processor\" do |sample|
  # to do: process body
end"
      end
      
      it "should generate a filter block" do
        helper.render(:process => :filter).should == 
"process \"sample filter\" do |sample|
  discard if false # to do: filter condition
end"
      end
      
      it "should generate a router block" do
        helper.render(:process => :router).should == 
"process \"sample router\" do |sample|
  # to do: write real conditions and uri's
  if condition1
    deliver :message => sample, :to => uri1
  elseif condition2
    deliver :message => sample, :to => uri2
  else
    deliver :message => sample, :to => uri3
  end
end"
      end
      
      it "should generate a message splitter" do
        helper.render(:process => :splitter).should ==
"process \"sample splitter\" do |sample|
  part1, part2, part3 = split(sample)
  # to do: write the real uri's
  deliver :message => part1, :to => uri1
  deliver :message => part2, :to => uri2
  deliver :message => part3, :to => uri3
end

def split(sample)
  # to do: write the splitting logic
  [sample, sample, sample]  
end"
      end
    end
  end
end
