gate :tests, :queue => true

process "http delivery" do |test|
  deliver :message => {:body => "you got it!"}, 
          :to => "http://localhost:3002/tests/"
end