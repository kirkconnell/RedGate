require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MeasurementsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "measurements", :action => "index").should == "/measurements"
    end

    it "maps #new" do
      route_for(:controller => "measurements", :action => "new").should == "/measurements/new"
    end

    it "maps #show" do
      route_for(:controller => "measurements", :action => "show", :id => "1").should == "/measurements/1"
    end

    it "maps #edit" do
      route_for(:controller => "measurements", :action => "edit", :id => "1").should == "/measurements/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "measurements", :action => "create").should == {:path => "/measurements", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "measurements", :action => "update", :id => "1").should == {:path =>"/measurements/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "measurements", :action => "destroy", :id => "1").should == {:path =>"/measurements/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/measurements").should == {:controller => "measurements", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/measurements/new").should == {:controller => "measurements", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/measurements").should == {:controller => "measurements", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/measurements/1").should == {:controller => "measurements", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/measurements/1/edit").should == {:controller => "measurements", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/measurements/1").should == {:controller => "measurements", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/measurements/1").should == {:controller => "measurements", :action => "destroy", :id => "1"}
    end
  end
end
