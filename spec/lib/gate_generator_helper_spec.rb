require 'spec_helper'

describe GateGeneratorHelper do
  class TestHelper
    include GateGeneratorHelper
  end
  
  let(:helper) { TestHelper.new }
  
  context "parsing arguments" do
    it "should give a list of parsed options" do
      helper.parse %w{--option1 --option2 --option=xxx uri1 uri2}
      helper.gate_options.first.should == "option1"
      helper.gate_options[1].should == "option2"
      helper.gate_options.last.should == "option"
    end
  
    it "should give a hash for options that have a specific value" do
      helper.parse %w{--option1 --option2=yyy --option3=xxx uri1 uri2}
      helper.gate_value_options[:option2].should == "yyy"
      helper.gate_value_options[:option3].should == "xxx"
    end
  
    it "should have no value options for arguments that have no value options" do
      helper.parse %w{--option1 --option2 uri1 uri2}
      helper.gate_value_options.should be_empty
    end
    
    it "should parse the list of receivers" do
      helper.parse %w{--option1 --option2 --option=xxx uri1 uri2}
      helper.receivers.first.should == "uri1"
      helper.receivers.last.should == "uri2"
    end
  end
  
  context "rendering" do
    context "gate defininition" do
      before(:each) do
        helper.stub!(:file_name).and_return "sample"
      end
      
      it "should render simple gate definitions" do
        helper.parse []
        helper.render(:gate_definition).should == "gate :sample"
      end
      
      it "should render queue gate definitions" do
        helper.parse %w{--queue}
        helper.render(:gate_definition).should == "gate :sample, :queue => true"
      end
      
      it "should render guaranteed gate definitions" do
        helper.parse %w{--guaranteed}
        helper.render(:gate_definition).should == "gate :sample, :guaranteed => true"
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
      it "should have an empty list of processes when no processing option is given" do
        helper.parse []
        helper.processes.should be_empty
      end
      
      it "should have a processor in the process list when the process option is given" do
        helper.parse %w{--processor}
        helper.processes.length.should == 1
        helper.processes.first.should == :processor
      end
      
      it "should have a filter in the process list when the filter option is given" do
        helper.parse %w{--processor --filter}
        helper.processes.should be_include :filter
      end
      
      it "should have a router in the process list when the router option is given" do
        helper.parse %w{--processor --filter --router}
        helper.processes.should be_include :router
      end
      
      it "should have a splitter in the process list when the splitter option is given" do
        helper.parse %w{--splitter}
        helper.processes.should be_include :splitter
      end
      
      it "should have a normalizer in the process list when the normalizer option is given" do
        helper.parse %w{--normalizer}
        helper.processes.should be_include :normalizer
      end
    end
  end
end
