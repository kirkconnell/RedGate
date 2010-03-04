gate :tests, :queue => true

pull :from => "http://localhost:3001/tests/"

process "http delivery" do |test|
  deliver :message => {:body => "you got it!"}, 
          :to => "http://localhost:3002/tests/"
end