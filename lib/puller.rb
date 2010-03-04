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
      thread_pool << Thread.start { run(pull, block) }
    end
    
    thread_pool.each { |t| t.join }
  end
    
  def self.run(pull, block)
    loop do
      messages = if pull.custom_pull.nil?
        pull.http_source.find(:all)
      elsif pull.custom_pull.arity == 0
        pull.custom_pull.call
      else
        pull.custom_pull.call(pull.http_source)
      end
      
      block.call(pull.uri, messages.count) unless block.nil?
      sleep(pull.interval)      
    end      
  end
  
  private
  def load_pulls
    Gate.registered_gates.values.collect{|gate| gate.pulls}.flatten
  end
end