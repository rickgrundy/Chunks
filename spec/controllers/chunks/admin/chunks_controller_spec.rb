require_relative "../../../spec_helper.rb"

describe Chunks::Admin::ChunksController do
  before(:each) do
    @page = Factory(:page)  
  end
  
  describe "creating a new chunk" do
    it "renders just the form for a new chunk with a specified type and container" do
      page = Factory(:page)
      get :new, page_id: page.id, type: "Chunks::BuiltIn::Html", container_key: "content"
      assigns(:chunk).should be_a Chunks::BuiltIn::Html
      assigns(:chunk).container_key.should == :content
      assigns(:chunk).should have(0).errors
      assigns(:page).should == page
      assigns(:page).container(:content).should have(1).chunks
      response.should_not render_template "layouts/chunks/admin/admin"
    end
  end
  
  describe "previewing a single chunk" do
    it "builds a chunk from chunks_chunk params" do
      chunk_params = {type: Chunks::BuiltIn::Text, content: "Something to preview"}
      post :preview, chunks_chunk: chunk_params
      response.should render_template "chunks/admin/chunk_preview"
      assigns(:chunk).should be_a Chunks::BuiltIn::Text
      assigns(:chunk).should be_a_new_record
      assigns(:chunk).content.should == "Something to preview"
    end
    
    it "builds a chunk from chunks_page nested params to allow a subset of a form to be previewed" do
      chunk_params = {type: Chunks::BuiltIn::Text, content: "Something to preview"}
      post :preview, chunks_page: {chunks_attributes: {"4" => chunk_params}}
      response.should render_template "chunks/admin/chunk_preview"
      assigns(:chunk).should be_a Chunks::BuiltIn::Text
      assigns(:chunk).should be_a_new_record
      assigns(:chunk).content.should == "Something to preview"
    end
    
    it "loads and updates an existing chunk without saving" do
      existing_chunk = Factory(:chunk, content: "Original content")
      chunk_params = {id: existing_chunk.id, type: Chunks::BuiltIn::Text, content: "Updated content"}
      post :preview, chunks_chunk: chunk_params
      response.should render_template "chunks/admin/chunk_preview"
      assigns(:chunk).should == existing_chunk
      assigns(:chunk).content.should == "Updated content"
      existing_chunk.reload.content.should == "Original content"
    end
  end
    
  it "destroys an existing chunk" do
    chunk = Factory(:chunk, page: @page)
    delete :destroy, id: chunk.id
    response.should redirect_to edit_chunks_admin_page_path(@page)
    @page.should have(0).chunks
  end
    
  describe "reordering a list of chunks" do
    before(:each) do
      @a = Factory(:chunk, page: @page, title: "A")
      @b = Factory(:chunk, page: @page, title: "B")
      @c = Factory(:chunk, page: @page, title: "C")
      verify_order(%w{A B C})
    end
    
    def verify_order(expected_order)
      @page = Chunks::Page.find(@page.id)
      @page.container(:content).chunks.map(&:title).should == expected_order
    end      
    
    it "moves a chunk higher in the list" do
      put :move_higher, id: @c.id
      response.should redirect_to edit_chunks_admin_page_path(@page)
      verify_order(%w{A C B})
    end  
        
    it "moves a chunk lower in the list" do
      put :move_lower, id: @a.id
      response.should redirect_to edit_chunks_admin_page_path(@page)
      verify_order(%w{B A C})
    end
  end
end