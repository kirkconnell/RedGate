class Puller
  include Singleton
  
  def pulls
    @pulls ||= load_pulls
  end
  
  def clear
    @pulls = nil
  end
  
  def self.start(&block)
    thread_pool = []
    
    instance.pulls.each do |pull|
      thread_pool << Thread.start { loop { iterate(pull, block) } }
    end
    
    thread_pool.each { |t| t.join }
  end
  
  def self.iterate(pull, block = nil)
    messages = pull_messages(pull)
    messages.each { |msg| Message.create!(:data => msg.attributes, :gate_name => pull.gate_name.to_s) }
    block.call(pull.uri, messages.count) unless block.nil?
    sleep(pull.interval)
  end
    
  def self.pull_messages(pull)
    if pull.custom_pull.nil?
      pull.http_source.find(:all)
    elsif pull.custom_pull.arity == 0
      pull.custom_pull.call
    else
      pull.custom_pull.call(pull.http_source)
    end
  end
  
  private
  def load_pulls
    Gate.registered_gates.values.collect{|gate| gate.pulls}.flatten
  end
end