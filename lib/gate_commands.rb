module GateCommands
end

def discard
  Message.current.discard!
end

def deliver(options={})
  message = options[:message]
  message ||= Message.current.data
  Message.current.gate.http_deliver message, options[:to]
end