require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GateBuilder do
  
  describe "defining a gate" do
    it "has a 'gate' method for defining a gate" do
      GateBuilder.should be_method_defined(:gate)
    end
    
    it "receives a symbol with the name of the gate" do
      method = GateBuilder.instance_method(:gate)
      method.arity.should_not == 0
    end
    
  end
end
