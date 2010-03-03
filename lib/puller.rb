class Puller
  include Singleton
  
  def pulls
    @pulls ||= load_pulls
  end
  
  private
  def load_pulls
    Gate.registered_gates.values.collect{|gate| gate.pulls}.flatten
  end
end