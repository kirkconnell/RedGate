require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/measurements/index.html.erb" do
  include MeasurementsHelper
  
  def message(stubs = {})
    @message ||= mock_model(Message, {:id => 1, :gate_name => :gate,
                                      :exactly_received_at => Time.now.to_f,
                                      :created_at => Time.now}.merge(stubs))
  end
  
  before(:each) do
    assigns[:measurements] = [
      stub_model(Measurement, :message => message, :created_at => Time.now, :sent_at => Time.now.to_f),
      stub_model(Measurement, :message => message, :created_at => Time.now, :sent_at => Time.now.to_f)
    ]
  end

  it "renders a list of measurements" do
    render
  end
end
