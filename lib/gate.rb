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
  attr_reader :processing_list, :receivers, :pulls

  def initialize(name, options={})
    self.name = name
    @processing_list = {}
    @receivers = subscribed_receivers
    @pulls = []
    @options = {:queue => false, :guaranteed => false}.merge(options)
    Gate.register self
  end
  
  def subscribed_receivers
    subscriptions = Subscription.find_by_gate_name(:all, name.to_s)
    if subscriptions.nil?
      []
    else
      subscriptions.collect { |subscription| subscription.uri }
    end
  end
  
  def guaranteed?
    @options[:guaranteed]
  end
  
  def queue?
    @options[:queue]
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
    if queue?
      message.push!
    else
      deliver_to_receivers(message)
    end
  end
  
  def deliver_to_receivers(message)
    raise "No receivers have been defined." if receivers.empty?
    receivers.each do |receiver|
      http_deliver message.data, receiver
    end
  end
  
  def http_deliver(message_data, receiver)
    logged_action "Delivering Message", receiver do
      http = Http::Delivery.new(:gate => name, :uri => receiver)
      http.data = message_data
      http.deliver
    end
  end
end
