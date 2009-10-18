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

class GateBuilder::Initializer
  def self.run
    yield
  end
end