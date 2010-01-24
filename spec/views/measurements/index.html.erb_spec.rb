require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/measurements/index.html.erb" do
  include MeasurementsHelper
  
  def message(stubs = {})
    @message ||= mock_model(Message, {:id => 1, :gate_name => :gate,
                                      :created_at => DateTime.now}.merge(stubs))
  end
  
  before(:each) do
    assigns[:measurements] = [
      stub_model(Measurement, :message => message, :sended_at => DateTime.now),
      stub_model(Measurement, :message => message, :sended_at => DateTime.now)
    ]
  end

  it "renders a list of measurements" do
    render
  end
end
