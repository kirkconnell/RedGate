class GatesController < ApplicationController

  def receive
    gate = Gate.find params[:gate_name]
    respond_to do |format|
      if gate
        data = get_data_from(params)
        @message = Message.new(:data => data, :gate_name => gate.name)
        if @message.save
          @message.send_later(:deliver!)
          format.xml {render :xml => @message, :status => :created }
        else
          @error = { :error => "Message couldn't be saved. \n #{@message.errors}" }
          format.xml { render :xml => @error, :status => :unprocessable_entity }
        end
      else
        @error = { :error => "Gate not found." }
        format.xml { render :xml => @error, :status => :unprocessable_entity }
      end
    end
  end
  
  def retrieve
    @error = { :error => "Gate not found." }
    respond_to do |format|
      format.xml { render :xml => @error, :status => 404 }
    end
  end
  
  private
  def get_data_from(params)
    params.each { |key, value| return value if value.kind_of?(Hash) }
  end
end
