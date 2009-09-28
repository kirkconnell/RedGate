class GatesController < ApplicationController

  def retrieve
    @error = { :error => "Gate not found." }
    respond_to do |format|
      format.xml { render :xml => @error, :status => 404 }
    end
  end
  
  def receive
    @error = { :error => "Gate not found." }
    @message = get_message_from(params)
    
    respond_to do |format|
      format.xml { render :xml => @error, :status => :unprocessable_entity }
    end
  end
  
  private
  def get_message_from(params)
    params.each { |key, value| return value if value.kind_of?(Hash) }
  end
end
