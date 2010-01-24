require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/measurements/show.html.erb" do
  include MeasurementsHelper
  before(:each) do
    assigns[:measurement] = @measurement = stub_model(Measurement)
  end

  it "renders attributes in <p>" do
    render
  end
end
