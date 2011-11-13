require_relative "../../../spec_helper.rb"

describe Chunks::Admin::PagesController do
  describe "creating a new page" do
    it "lists all available templates" do
      get :new
      assigns(:page).template.should be_nil
      assigns(:available_templates).should == Chunks.config.templates
    end
    
    it "allows a template to be specified" do
      get :new, :template => Chunks::BuiltIn::Template::SingleColumn
      assigns(:page).template.should == Chunks::BuiltIn::Template::SingleColumn
      assigns(:available_templates).should be_nil
    end
    
    it "creates a page successfully" do
      post :create, chunks_page: {title: "Test Page", template: Chunks::BuiltIn::Template::SingleColumn}
      response.should redirect_to edit_chunks_admin_page_path(assigns(:page))
    end
    
    it "fails on validation errors" do
      post :create, chunks_page: {}
      response.status.should == 500
      response.should render_template "chunks/admin/pages/edit"
      assigns(:available_templates).should == Chunks.config.templates
    end
    
    it "does not allow a specified template to be changed on validation errors" do
      post :create, chunks_page: {}, :template => Chunks::BuiltIn::Template::SingleColumn
      response.status.should == 500
      assigns(:available_templates).should be_nil
    end
  end
  
  describe "editing an existing page" do
    before(:each) do
      @page = Factory(:page)
    end
    
    it "does not allow the template to be changed" do
      get :edit, id: @page
      assigns(:page).should == @page
      assigns(:available_templates).should be_nil
    end
    
    it "updates a page successfully" do
      put :update, id: @page, chunks_page: {title: "A New Title"}
      response.should redirect_to chunks_admin_pages_path
      @page.reload.title.should == "A New Title"
    end
    
    it "fails on validation errors" do
      put :update, id: @page, chunks_page: {title: nil}
      response.status.should == 500
      response.should render_template "chunks/admin/pages/edit"
      assigns(:available_templates).should be_nil
    end
  end
  
  describe "listing pages" do
    before(:each) do
      Chunks::Page.destroy_all
    end
    
    it "filters by template" do
      Factory(:page, template: Chunks::BuiltIn::Template::TwoColumn.to_s)
      Factory(:page, template: Chunks::BuiltIn::Template::SingleColumn.to_s)
      Factory(:page, template: Chunks::BuiltIn::Template::TwoColumn.to_s)
      get :index, template: Chunks::BuiltIn::Template::TwoColumn
      assigns(:pages).should have(2).things
    end
    
    it "searches by name" do
      Factory(:page, title: "Test page 1")
      Factory(:page, title: "Test PAGE 2")
      Factory(:page, title: "Test ???? 3")
      get :index, q: "page"
      assigns(:pages).should have(2).things
    end
  end
end