class Delivery::HttpDelivery
  attr_accessor :ar
  
  def initialize(options={})
    options.merge!(extract_options_from(options[:uri]))
    @host = options[:host]
    @element = options[:element]
    @gate_name = options[:gate]
    @stored_classes = {}
  end
  
  def instructions
    "self.site = '#{@host}'; self.element_name = '#{@element}';" unless @host.blank? || @element.blank?
  end
  
  def ar_class_name
    "#{@gate_name.to_s.classify}Delivery"
  end
  
  def ar_key
    [@gate_name, @host].join('-')
  end
  
  def load_with(data)
    unless stored_type_for(@gate_name, @host)
      eval "class #{ar_class_name} < ActiveResource::Base; #{instructions} end"
      self.ar = eval("#{ar_class_name}.new(data)")
      @stored_classes[ar_key] = self.ar.class
      self.ar
    else
      self.ar = stored_type_for(@gate_name, @host).new(data)
    end
  end
  
  def stored_type_for(gate, host)
    @stored_classes[ar_key]
  end
  
  def deliver
    if ar.nil?
      raise "The MessageDelivery object hasn't been created yet."
    else
      ar.save
    end
  end
  
  def extract_options_from(uri)
    if /(https?:\/\/.*\/)(.*)\// === slasherize(uri)
      { :host => $1.to_s, 
        :element => ActiveSupport::Inflector.singularize($2).to_s }
    else
      raise "The receiver uri '#{receiver_uri}' was not defined correctly."
    end
  end
  
  private
  def slasherize(string)
    if string.last == '/'
      string
    else
      string + "/"
    end
  end
    
end