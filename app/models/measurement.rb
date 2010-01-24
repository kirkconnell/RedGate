class Measurement < ActiveRecord::Base
  belongs_to :message
  
  def self.record(message)
    Measurement.create! :message_id => message.id,
                        :gate_name => message.gate_name,
                        :sended_at => DateTime.now
  end
  
  def received_at
    message.created_at
  end
  
  def interval
    created_at - received_at
  end
end
