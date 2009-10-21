require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TestLoggedAction
  include LoggedAction
end


describe LoggedAction do
  before(:each) do
    @logged = TestLoggedAction.new
    @logged.logger = mock("logger", :info => true)
  end
  
  it "should log a successful run of an action" do
    @logged.should_receive(:begin_action)
    @logged.should_receive(:complete_action)
    @logged.logged_action("rspec", "test") { "test" }
  end
  
  it "should log an error on a run of an action" do
    @logged.should_receive(:begin_action)
    @logged.should_receive(:fail_action)
    lambda {@logged.logged_action("rspec", "test") { raise "error" }}.should raise_error
  end
  
end