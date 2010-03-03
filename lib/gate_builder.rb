module GateBuilder
end

def gate(name, options={})
  Gate.new(name, options)
end

def process(description, &block)
  Gate.currently_configuring.processing_list[description] = block
end

def receiver(host)
  raise "Queue gates can't have receivers specified." if Gate.currently_configuring.queue?
  Gate.currently_configuring.receivers << host
end

def receivers(*hosts)
  raise "Queue gates can't have receivers specified." if Gate.currently_configuring.queue?
  hosts.each { |h| Gate.currently_configuring.receivers << h }
end

def pull(options={})
  options[:interval] ||= 300 # This is Sparta!!!
  options[:gate] = Gate.currently_configuring.name
  if options[:from].kind_of? Array
    options[:from].each do |source|
      Gate.currently_configuring.pulls << Http::Pull.new(options.merge({:from => source}))
    end
  else
    Gate.currently_configuring.pulls << Http::Pull.new(options)
  end
end

class GateBuilder::Initializer  
  def self.run
    yield
  end
end