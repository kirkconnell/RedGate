module GateCommands
end

def discard
  Message.current.discard!
end