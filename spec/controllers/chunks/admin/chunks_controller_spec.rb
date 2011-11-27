require_relative "../../../spec_helper.rb"

describe Chunks::Admin::ChunksController do
  before(:each) do
    @page = Factory(:page)  
  end
  
  describe "creating a new chunk" do
    it "renders just the form for a new chunk with a specified type and container" do
      page = Factory(:page)
      get :new, use_route: "chunks", page_id: page.id, type: "Chunks::BuiltIn::Html", container_key: "content"
      assigns(:chunk).should be_a Chunks::BuiltIn::Html
      assigns(:chunk).should have(0).errors
      assigns(:page).should == page
      assigns(:page).container(:content).should have(1).chunks
      response.should_not render_template "layouts/chunks/admin/admin"
    end
  end
  
  describe "previewing a single chunk" do
    it "builds a chunk from chunk params" do
      chunk_params = {type: Chunks::BuiltIn::Text, content: "Something to preview"}
      post :preview, use_route: "chunks", chunk: chunk_params
      response.should render_template "chunks/admin/chunk_preview"
      assigns(:chunk).should be_a Chunks::BuiltIn::Text
      assigns(:chunk).should be_a_new_record
      assigns(:chunk).content.should == "Something to preview"
    end
    
    it "builds a chunk from page nested params to allow a subset of a form to be previewed" do
      chunk_params = {type: Chunks::BuiltIn::Text, content: "Something to preview"}
      post :preview, use_route: "chunks", page: {chunks_attributes: {"4" => chunk_params}}
      response.should render_template "chunks/admin/chunk_preview"
      assigns(:chunk).should be_a Chunks::BuiltIn::Text
      assigns(:chunk).should be_a_new_record
      assigns(:chunk).content.should == "Something to preview"
    end
    
    it "loads and updates an existing chunk without saving" do
      existing_chunk = Factory(:chunk, content: "Original content")
      chunk_params = {id: existing_chunk.id, type: Chunks::BuiltIn::Text, content: "Updated content"}
      post :preview, use_route: "chunks", chunk: chunk_params
      response.should render_template "chunks/admin/chunk_preview"
      assigns(:chunk).should == existing_chunk
      assigns(:chunk).content.should == "Updated content"
      existing_chunk.reload.content.should == "Original content"
    end
  end
end