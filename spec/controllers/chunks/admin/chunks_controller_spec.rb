require_relative "../../../spec_helper.rb"

describe Chunks::Admin::ChunksController do
  describe "creating a new chunk" do
    it "creates a chunk successfully without validating" do
      page = Factory(:page)
      post :create, page_id: page.id, container_key: page.containers.first.key, type: Chunks::BuiltIn::Text
      response.should redirect_to edit_chunks_admin_page_path(page)
      page.reload
      page.should have(1).chunk
    end
    
    it "destroys an existing chunk" do
      chunk = Factory(:chunk)
      delete :destroy, id: chunk.id
      page = chunk.page
      response.should redirect_to edit_chunks_admin_page_path(page)
      page.should have(0).chunks
    end
  end
end