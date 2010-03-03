class Http::Pull
  include Http::URIAnalizer
  include Http::ActiveResourceGenerator
  attr_accessor :block
  
  def initialize(options={})
    options[:interval] ||= 300
    raise "A source URI is required to create an HttpPuller." if options[:from].nil?
    @options = options.merge(extract_options_from(options[:from]))
    initialize_type_store @options
  end
  
  def interval
    @options[:interval]
  end
  
  def uri
    @options[:from]
  end
  
  def http_source
    generate_type
    stored_type
  end 
end