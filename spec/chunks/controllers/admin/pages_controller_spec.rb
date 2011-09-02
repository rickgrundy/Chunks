require File.expand_path("../../../../spec_helper.rb", __FILE__)

describe Chunks::Admin::PagesController do
  describe "creating a new page" do
    it "lists all available templates" do
      get :new
      assigns(:templates).should == Chunks::Template.all
    end
    
    it "creates a page successfully" do
      post :create, chunks_page: {title: "Test Page", template: "Chunks::Template::SingleColumn"}
      response.should redirect_to chunks_admin_pages_path
    end
    
    it "fails on validation errors" do
      post :create, chunks_page: {}
      response.status.should == 500
      response.should render_template "chunks/admin/pages/edit"
    end
  end
end