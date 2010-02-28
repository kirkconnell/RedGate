require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GateCommands do
  describe "providing content based filter" do
    it "should allow to discard messages from a processing gate" do
      Message.should_receive(:current).and_return(mock_message)
      discard
    end
  end
  
  describe "providing content based router" do
    def mock_gate
      @mock_gate ||= mock(Gate, :http_deliver => true)
    end
    
    def mock_message
      @mock_message ||= mock(Message, :gate => mock_gate, :data => {:field => "sample"})
    end
    
    it "should provide a way to dynamically send the message to a recipient" do
      mock_gate.should_receive :http_deliver
      Message.should_receive(:current).twice.and_return(mock_message)
      deliver :to => "http://www.google.com/service"
    end

    it "should provide a way to specify a message different from the current received message" do
      different_msg = {:field => "something else"}
      Message.should_receive(:current).and_return(mock_message)
      mock_gate.should_receive(:http_deliver)

      deliver :message => different_msg, :to => "http://www.google.com/service"
    end
  end
end
