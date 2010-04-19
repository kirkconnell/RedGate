class SubscriptionController < ApplicationController
  
  def index
    @subscriptions = Subscription.all
    render :xml => @susbscriptions
  end

  def show
    @subscription = Subscription.find(params[:id])
    render :xml => @subscription
  end

  def create
    @subscription = Subscription.create!(params)
    render :xml => @subscription
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    render :nothing => true
  end

end
