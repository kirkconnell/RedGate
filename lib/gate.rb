require 'gate_commands'

class Gate
  include LoggedAction
  
  def self.register(gate)
    GATES[gate.name] = gate
    @@currently_configuring = gate
  end
  
  def self.registered_gates
    GATES
  end
  
  def self.currently_configuring
    @@currently_configuring
  end
  
  def self.find(gate_name)
    gate_name = gate_name.to_sym if gate_name.instance_of?(String)
    registered_gates[gate_name]
  end
  
  attr_accessor :name
  attr_reader :processing_list, :receivers

  def initialize(name, options={})
    self.name = name
    @processing_list = {}
    @receivers = []
    Gate.register self
  end
  
  def process(message)
    return if message.discarded?
    Message.current = message
    processing_list.each do |description, proc|
      logged_action "Running Process", description do
        proc.call(message.data)
      end
      return if message.discarded?
    end
  end
  
  def deliver(message)
    return if message.discarded?
    deliver_to_receivers(message)
  end
  
  def deliver_to_receivers(message)
    raise "No receivers have been defined." if receivers.empty?
    
    receivers.each do |receiver|
      logged_action "Delivering Message", receiver do
        strat = DeliveryStrategy.for name, receiver
        strat.load_with(message.data)
        strat.deliver
      end
    end
  end
end
