GateBuilder::Initializer.run do
  Dir["#{File.dirname(__FILE__)}/../gates/*.rb"].each {|f| require f}
end