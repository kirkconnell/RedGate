class Message < ActiveRecord::Base
  def gate
    Gate.registered_gates[self.gate_name.to_sym]
  end
end
