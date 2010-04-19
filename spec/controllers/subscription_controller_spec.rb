require 'spec_helper'

describe SubscriptionController do

  it "should use SubscriptionController" do
    controller.should be_an_instance_of(SubscriptionController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      Subscription.should_receive(:find).with("1").and_return mock(Subscription)
      get 'show', :id => 1
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should be successful" do
      Subscription.should_receive(:create!).and_return mock(Subscription)
      post 'create', :gate_name => "sample", :uri => "http://sample.com"
      response.should be_success
    end
  end

  describe "delete 'destroy'" do
    it "should be successful" do
      s = mock(Subscription, :destroy => true)
      Subscription.should_receive(:find).with("1").and_return s
      delete 'destroy', :id => 1
      response.should be_success
    end
  end
end
