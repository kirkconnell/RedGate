class MessageWorker < Workling::Base
  def deliver(options={})
    options[:message].deliver!
  end
end