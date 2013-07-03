require_relative "../../../spec_helper.rb"

describe Chunks::Admin::ChunksController do
  before(:each) do
    @page = FactoryGirl.create(:page)  
  end
  
  describe "creating a new chunk" do
    it "renders just the form for a new chunk with a specified type and container" do
      page = FactoryGirl.create(:page)
      get :new, use_route: "chunks", page_id: page.id, type: "Chunks::BuiltIn::Html", container_key: "content"
      assigns(:chunk).should be_a Chunks::BuiltIn::Html
      assigns(:chunk).should have(0).errors
      assigns(:page).should == page
      assigns(:page).container(:content).should have(1).chunks
      response.should_not render_template "layouts/chunks/admin/admin"
    end
  end
  
  describe "previewing a single chunk" do
    it "builds a chunk from shared chunk params" do
      shared_chunk_params = {chunk_attributes: {type: Chunks::BuiltIn::Text, content: "Something to preview", container_key: "sidebar"}}
      post :preview, use_route: "chunks", shared_chunk: shared_chunk_params
      response.should render_template "chunks/admin/chunk_preview"
      chunk = assigns(:chunk)
      chunk.should be_a Chunks::BuiltIn::Text
      chunk.should be_a_new_record
      chunk.content.should == "Something to preview"
      chunk.container_key.should == :sidebar
    end
    
    it "builds a chunk from page nested params to allow a subset of a form to be previewed" do
      chunk_params = {type: Chunks::BuiltIn::Text, content: "Something to preview"}
      post :preview, use_route: "chunks", page: {chunks_attributes: {"4" => chunk_params}}
      response.should render_template "chunks/admin/chunk_preview"
      chunk = assigns(:chunk)
      chunk.should be_a Chunks::BuiltIn::Text
      chunk.should be_a_new_record
      chunk.content.should == "Something to preview"
    end
    
    it "loads and updates an existing chunk without saving" do
      existing_chunk = FactoryGirl.create(:chunk, content: "Original content")
      chunk_params = {id: existing_chunk.id, type: Chunks::BuiltIn::Text, content: "Updated content"}
      post :preview, use_route: "chunks", chunk: chunk_params
      response.should render_template "chunks/admin/chunk_preview"
      chunk = assigns(:chunk)
      chunk.should == existing_chunk
      chunk.content.should == "Updated content"
      existing_chunk.reload.content.should == "Original content"
    end
  end
  
  describe "sharing a chunk between pages" do
    before(:each) do
      @chunk = FactoryGirl.create(:chunk)
    end
    
    it "creates a new shared chunk" do
      post :share, use_route: "chunks", id: @chunk.id, name: "A picture of a bunny"
      @chunk.should be_shared
      Chunks::SharedChunk.find_by_chunk_id(@chunk.id).name.should == "A picture of a bunny"
    end
    
    it "returns validation errors as JSON" do
      post :share, use_route: "chunks", id: @chunk.id, name: ""
      response.status.should == 500
      response.body.should include "can't be blank"
      @chunk.should_not be_shared
    end
    
    it "renders the shared new chunk for inclusion on another page" do
      shared = FactoryGirl.create(:shared_chunk)
      page = FactoryGirl.create(:page)
      get :include, use_route: "chunks", id: shared.chunk, page_id: page.id, container_key: "content"
      assigns(:chunk).should be_a Chunks::BuiltIn::Text
      assigns(:chunk).should have(0).errors
      assigns(:page).should == page
      assigns(:page).container(:content).should have(1).chunks
      response.should_not render_template "layouts/chunks/admin/admin"
    end
  end
end