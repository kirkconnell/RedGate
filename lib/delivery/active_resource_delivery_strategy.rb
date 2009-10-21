class Delivery::ActiveResourceDeliveryStrategy
  attr_accessor :ar
  
  def initialize(options={})
    @host = options[:host]
    @element = options[:element]
  end
  
  def instructions
    "self.site = '#{@host}'; self.element_name = '#{@element}';" unless @host.blank? || @element.blank?
  end
  
  def load_with(data)
    eval "class MessageDelivery < ActiveResource::Base; #{instructions} end"
    self.ar = eval("MessageDelivery.new(data)")
  end
  
  def deliver
    if ar.nil?
      raise "The MessageDelivery object hasn't been created yet."
    else
      ar.save
    end
  end
    
end