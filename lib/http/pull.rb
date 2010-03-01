class Http::Pull
  def initialize(options={})
    options[:interval] ||= 300
    raise "A source URI is required to create an HttpPuller." if options[:from].nil?
    @options = options
  end
  
  def interval
    @options[:interval]
  end
  
  def http_source
    "whatever!"
  end 
end