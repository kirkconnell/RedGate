module LoggedAction
  attr_accessor :logger
  
  def logged_action(actor, description)
    begin_action actor, description
    yield
    complete_action actor, description
  rescue Exception => error
    fail_action actor, description, error
    raise error
  end
  
private  
  def begin_action(actor, description)
    log "#{actor}
    #{description}
    Action Starting..." 
  end
  
  def complete_action(actor, description)
    log "#{actor}
    Action Completed: #{description}"
  end
  
  def fail_action(actor, description, error)
    log "#{actor}
    #{description}
    Action Failure...
    Exception: #{error.to_s}"
  end
  
  def log(event)
    logger.info event unless logger.nil?
    #p event
  end
end