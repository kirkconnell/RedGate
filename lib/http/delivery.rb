class Http::Delivery
  include Http::URIAnalizer
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
  
  def stored_type
    @stored_classes[ar_key]
  end
  
  def load_with(data)
    unless stored_type
      eval "class #{ar_class_name} < ActiveResource::Base; #{instructions} end"
      @stored_classes[ar_key] = eval("#{ar_class_name}")
    end
    self.ar = stored_type.new(data)
  end
  
  def deliver
    if ar.nil?
      raise "The ActiveResource object hasn't been created yet."
    else
      ar.save
    end
  end    
end