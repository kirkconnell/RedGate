class DeliveryStrategy
  def self.for(gate, receiver)
    Delivery::ActiveResourceDeliveryStrategy.new options_for(gate, slasherize(receiver))
  end
  
  def self.options_for(gate, receiver_uri)
    if /(https?:\/\/.*\/)(.*)\// === receiver_uri
      options = {}
      options[:host] = $1.to_s
      options[:element] = ActiveSupport::Inflector.singularize($2).to_s
      options[:gate] = gate
      options
    else
      raise "The receiver uri '#{receiver_uri}' was not defined correctly."
    end
  end
  
  def self.slasherize(string)
    if string.last == '/'
      string
    else
      string + "/"
    end
  end 
end