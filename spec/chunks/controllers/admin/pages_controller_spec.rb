require_relative "../../../spec_helper.rb"

describe Chunks::Admin::PagesController do
  describe "creating a new page" do
    it "lists all available templates" do
      get :new
      assigns(:available_templates).should == Chunks::AllTemplates
      assigns(:page).template.should be_nil
    end
    
    it "allows a template to be specified" do
      get :new, :template => Chunks::BuiltIn::Template::SingleColumn
      assigns(:page).template.should == Chunks::BuiltIn::Template::SingleColumn
    end
    
    it "creates a page successfully" do
      post :create, chunks_page: {title: "Test Page", template: "Chunks::BuiltIn::Template::SingleColumn"}
      response.should redirect_to chunks_admin_pages_path
    end
    
    it "fails on validation errors" do
      post :create, chunks_page: {}
      response.status.should == 500
      response.should render_template "chunks/admin/pages/edit"
    end
  end
end