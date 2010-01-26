module GateBuilder
end

def gate(name, options={})
  Gate.new(name, options)
end

def process(description, &block)
  Gate.currently_configuring.processing_list[description] = block
end

def receiver(host)
  Gate.currently_configuring.receivers << host
end

def receivers(*hosts)
  hosts.each { |h| Gate.currently_configuring.receivers << h }
end

class GateBuilder::Initializer  
  def self.run
    yield
  end
end