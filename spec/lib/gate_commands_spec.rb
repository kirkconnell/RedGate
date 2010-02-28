require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GateCommands do
  it "should allow to discard messages from a processing gate" do
    Message.should_receive(:current).and_return(mock_message)
    discard
  end
  
  it "should provide a way to dynamically send the message to a recipient" do
    Gate.should_receive :http_deliver
    deliver :to => "http://www.google.com/service"
  end
end
