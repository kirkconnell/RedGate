require File.dirname(__FILE__) + '/../spec_helper'

describe MessageWorker do
  it "should call deliver to messages sent" do
    msg = mock(Message, :deliver! => true)
    msg.should_receive(:deliver!)
    
    worker = MessageWorker.new
    worker.deliver :message => msg
  end
end