require_relative "../../../spec_helper.rb"

describe Chunks::Admin::PagesController do
  describe "creating a new page" do
    it "lists all available templates" do
      get :new, use_route: "chunks"
      assigns(:page).template.should be_nil
      assigns(:available_templates).should == Chunks.config.templates
    end
    
    it "allows a template to be specified" do
      get :new, use_route: "chunks", :template => Chunks::BuiltIn::Template::SingleColumn
      assigns(:page).template.should == Chunks::BuiltIn::Template::SingleColumn
      assigns(:available_templates).should be_nil
    end
    
    it "creates a page successfully" do
      post :create, use_route: "chunks", page: {title: "Test Page", template: Chunks::BuiltIn::Template::SingleColumn}
      response.should redirect_to edit_admin_page_path(assigns(:page))
    end
    
    it "fails on validation errors" do
      post :create, use_route: "chunks", page: {}
      response.status.should == 500
      response.should render_template "chunks/admin/pages/edit"
      assigns(:available_templates).should == Chunks.config.templates
    end
    
    it "does not allow a specified template to be changed on validation errors" do
      post :create, use_route: "chunks", page: {}, :template => Chunks::BuiltIn::Template::SingleColumn
      response.status.should == 500
      assigns(:available_templates).should be_nil
    end
  end
  
  describe "editing an existing page" do
    before(:each) do
      @page = Factory(:two_column_page)
    end
    
    it "does not allow the template to be changed" do
      get :edit, use_route: "chunks", id: @page
      assigns(:page).should == @page
      assigns(:available_templates).should be_nil
    end
    
    it "loads a page along with all chunks in correct containers" do
      chunk = Factory(:chunk)
      Factory(:chunk_usage, page: @page, chunk: chunk, container_key: "main_content")
      Factory(:chunk_usage, page: @page, chunk: chunk, container_key: "sidebar")
      get :edit, use_route: "chunks", id: @page
      assigns(:page).container(:sidebar).should have(1).chunk
      assigns(:page).container(:main_content).should have(1).chunk
    end
    
    it "updates a page successfully" do
      put :update, use_route: "chunks", id: @page, page: {title: "A New Title"}
      response.should redirect_to admin_pages_path
      @page.reload.title.should == "A New Title"
    end
    
    it "fails on validation errors" do
      put :update, use_route: "chunks", id: @page, page: {title: nil}
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
      get :index, use_route: "chunks", template: Chunks::BuiltIn::Template::TwoColumn
      assigns(:pages).should have(2).things
    end
    
    it "searches by name" do
      Factory(:page, title: "Test page 1")
      Factory(:page, title: "Test PAGE 2")
      Factory(:page, title: "Test ???? 3")
      get :index, use_route: "chunks", q: "page"
      assigns(:pages).should have(2).things
    end
  end
end