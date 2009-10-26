class Message < ActiveRecord::Base  
  serialize :data
  
  def gate
    Gate.registered_gates[self.gate_name.to_sym]
  end
  
  def deliver!
    gate.process self
    gate.deliver_to_receivers self
  end
    
end
