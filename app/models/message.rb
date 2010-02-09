class Message < ActiveRecord::Base  
  serialize :data
  has_one :measurement, :dependent => :destroy
  
  def before_create
    self.exactly_received_at = Time.now.to_f
  end
  
  def gate
    Gate.registered_gates[self.gate_name.to_sym]
  end
  
  def deliver!
    gate.process self
    gate.deliver_to_receivers self

    # todo: define a configuration to disable performance measurements
    Measurement.record self
  end
  
  def discard!
    self.update_attribute(:discarded, true)
  end

  # todo: make threadsafe
  def self.current=(message)
    @@current = message
  end
  
  def self.current
    @@current
  end
    
end
