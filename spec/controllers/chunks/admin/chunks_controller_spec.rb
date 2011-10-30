require_relative "../../../spec_helper.rb"

describe Chunks::Admin::ChunksController do
  before(:each) do
    @page = Factory(:page)  
  end
  
  describe "creating a new chunk" do
    it "creates a chunk successfully without validating" do
      post :create, page_id: @page.id, container_key: @page.containers.first.key, type: Chunks::BuiltIn::Text
      response.should redirect_to edit_chunks_admin_page_path(@page)
      @page.reload
      @page.should have(1).chunk
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
      end
      
      def verify_order(expected_order)
        @page.reload
        @page.container(:main).chunks.map(&:title).should == expected_order
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
end