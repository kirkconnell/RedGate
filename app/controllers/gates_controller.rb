class GatesController < ApplicationController

  def receive
    gate = Gate.find(params[:gate_name])
    respond_to do |format|
      if gate
        data = get_data_from(params)
        @message = Message.new(:data => data, :gate_name => gate.name.to_s)
        if @message.save
          format.xml { render :nothing => true, :status => :created }
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
    gate = Gate.find(params[:gate_name])
    respond_to do |format|
      if gate
        @message = Message.pop!(params[:gate_name])
        if @message.nil?
          format.xml { render :nothing => true, :status => 404 }
        else
          format.xml{ render :xml => @message.data.to_xml(:root=> @message.gate_name.singularize) }
        end
      else
        @error = { :error => "Gate not found." }
        format.xml { render :xml => @error, :status => 404 }
      end
    end
  end
  
  private
  def get_data_from(params)
    params.each { |key, value| return value if value.kind_of?(Hash) }
  end
end
