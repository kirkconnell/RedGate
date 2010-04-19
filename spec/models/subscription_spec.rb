require 'spec_helper'

describe Subscription do
  before(:each) do
    @valid_attributes = {
      :gate_name => "value for gate_name",
      :uri => "value for uri"
    }
  end

  it "should create a new instance given valid attributes" do
    Subscription.create!(@valid_attributes)
  end
end
