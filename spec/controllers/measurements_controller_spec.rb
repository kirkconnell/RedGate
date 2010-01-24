require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MeasurementsController do

  def mock_measurement(stubs={})
    @mock_measurement ||= mock_model(Measurement, stubs)
  end

  describe "GET index" do
    it "assigns all measurements as @measurements" do
      Measurement.stub!(:find).with(:all).and_return([mock_measurement])
      get :index
      assigns[:measurements].should == [mock_measurement]
    end
  end

  describe "GET show" do
    it "assigns the requested measurement as @measurement" do
      Measurement.stub!(:find).with("37").and_return(mock_measurement)
      get :show, :id => "37"
      assigns[:measurement].should equal(mock_measurement)
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested measurement" do
      Measurement.should_receive(:find).with("37").and_return(mock_measurement)
      mock_measurement.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the measurements list" do
      Measurement.stub!(:find).and_return(mock_measurement(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(measurements_url)
    end
  end

end
