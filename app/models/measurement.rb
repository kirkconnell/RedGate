class Measurement < ActiveRecord::Base
  belongs_to :message
  
  def self.record(message)
    Measurement.create! :message_id => message.id,
                        :gate_name => message.gate_name,
                        :sent_at => Time.now.to_f
  end
  
  def received_at
    message.created_at
  end
  
  def exactly_received_at
    message.exactly_received_at
  end
  
  def interval
    sent_at - exactly_received_at
  end
end
