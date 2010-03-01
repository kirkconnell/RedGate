module Http::ActiveResourceGenerator
  def initialize_type_store(options={})
    validate_required_options(options)
    @host = options[:host]
    @element = options[:element]
    @gate_name = options[:gate]
    @stored_classes = {}
  end
  
  def validate_required_options(options)
    raise 'Host option is required to build an ActiveResource class.' if options[:host].nil?
    raise 'Element option is required to build an ActiveResource class.' if options[:element].nil?
    raise 'Gate option is required to store an ActiveResource class.' if options[:gate].nil?
  end
  
  def instructions
    "self.site = '#{@host}'; self.element_name = '#{@element}';" unless @host.blank? || @element.blank?
  end
  
  def ar_class_name
    "#{@element.to_s.classify}"
  end
  
  def ar_key
    [@gate_name, @host].join('-')
  end
  
  def stored_type
    @stored_classes[ar_key]
  end
  
  def store(type)
    @stored_classes[ar_key] = type
  end
  
  def generate_type
    unless stored_type
      eval "class #{ar_class_name} < ActiveResource::Base; #{instructions} end"
      store eval("#{ar_class_name}")
    end
  end
end