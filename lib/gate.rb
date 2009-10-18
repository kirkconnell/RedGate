class Gate
  attr_accessor :name
  attr_reader :processing_list, :receivers

  def initialize(name, options={})
    self.name = name
    @processing_list = {}
    @receivers = []
    Gate.register self
  end
  
  def self.register(gate)
    @@gates ||= {}
    @@gates[gate.name] = gate
    @@currently_configuring = gate
  end
  
  def self.registered_gates
    @@gates
  end
  
  def self.currently_configuring
    @@currently_configuring
  end
end