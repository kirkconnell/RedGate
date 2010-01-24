class MeasurementsController < ApplicationController
  # GET /measurements
  # GET /measurements.xml
  def index
    @measurements = Measurement.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @measurements }
    end
  end

  # GET /measurements/1
  # GET /measurements/1.xml
  def show
    @measurement = Measurement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @measurement }
    end
  end

  # DELETE /measurements/1
  # DELETE /measurements/1.xml
  def destroy
    @measurement = Measurement.find(params[:id])
    @measurement.destroy

    respond_to do |format|
      format.html { redirect_to(measurements_url) }
      format.xml  { head :ok }
    end
  end
end
