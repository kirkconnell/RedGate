class Http::Delivery
  include Http::URIAnalizer
  include Http::ActiveResourceGenerator
  attr_accessor :ar
  
  def initialize(options={})
    options.merge!(extract_options_from(options[:uri]))
    initialize_type_store(options)
  end
  
  def data
    @data
  end
    
  def data=(hash)
    @data = hash
    generate_type
    self.ar = stored_type.new(@data)
  end
  
  def deliver
    if ar.nil?
      raise "The ActiveResource object hasn't been created yet."
    else
      ar.save
    end
  end    
end