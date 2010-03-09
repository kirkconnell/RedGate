class Message < ActiveRecord::Base  
  serialize :data
  has_one :measurement, :dependent => :destroy
  
  def before_create
    self.exactly_received_at = Time.now.to_f
    push!(:dont_save => true) unless needs_to_be_delayed?
  end
  
  def after_create
    schedule_delivery if needs_to_be_delayed?
  end
  
  def gate
    Gate.registered_gates[self.gate_name.to_sym]
  end
  
  def schedule_delivery
    send_later :deliver!
  end
  
  def deliver!
    gate.process self
    gate.deliver self
    Measurement.record self
  end
  
  def discard!
    self.update_attribute(:discarded, true)
  end
  
  def needs_to_be_delayed?
    if gate.queue?
      !gate.processing_list.empty?
    else
      true
    end
  end
  
  def push!(options={})
    self.in_queue = true
    save! unless options[:dont_save]
  end
  
  def self.pop!(gate_name)
    msg = find( :first, :conditions => ["in_queue = ? and gate_name = ?", true, gate_name], 
                :order => "exactly_received_at")
    unless msg.nil?
      Message.transaction do
        msg.update_attribute :in_queue, false
        Measurement.record msg
      end
    end
    msg
  end

  # todo: make threadsafe
  def self.current=(message)
    @@current = message
  end
  
  def self.current
    @@current
  end
    
end
