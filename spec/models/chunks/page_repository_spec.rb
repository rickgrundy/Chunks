require_relative "../../spec_helper.rb"

describe Chunks::Page do
  before(:each) do
    @repository = Chunks::PageRepository.new
    @page = Factory(:two_column_page)
  end
  
  it "loads a page with all chunks in correct containers" do
    chunk = Factory(:chunk)
    Factory(:chunk_usage, page: @page, chunk: chunk, container_key: "main_content")
    Factory(:chunk_usage, page: @page, chunk: chunk, container_key: "sidebar")
    loaded_page = @repository.find(@page.id)
    loaded_page.container(:sidebar).should have(1).chunk
    loaded_page.container(:main_content).should have(1).chunk
  end
  
  it "updates basic page attributes" do
    @repository.update(@page, title: "A more interesting title")
    @page.reload.title.should == "A more interesting title"
  end
    
  describe "updating chunks" do    
    it "updates existing chunks" do
      usage = Factory(:chunk_usage, page: @page)
      attrs = {chunks_attributes: { "0" => {
        type: "Chunks::BuiltIn::Html",
        title: "Updated!",
        id: usage.chunk.id.to_s
      }}}
      @repository.update(@page.reload, attrs).should be_true
      @page.should have(1).chunk
      @page.chunks.first.title.should == "Updated!"
      @page.reload.chunks.first.title.should == "Updated!"
    end
    
    it "creates new chunks of specified type" do
      attrs = {chunks_attributes: { "0" => {
        type: "Chunks::BuiltIn::Html",
        content: "Valid content",
        title: "New!",
        container_key: "main_content",
        position: "1"
      }}}
      @repository.update(@page.reload, attrs).should be_true
      @page.should have(1).chunk
      @page.chunks.first.should be_a Chunks::BuiltIn::Html
      @page.chunks.first.title.should == "New!"
    end   
    
    it "reorders chunks" do
      chunk1 = Factory(:chunk, title: "First")
      chunk2 = Factory(:chunk, title: "Second")
      Factory(:chunk_usage, page: @page, chunk: chunk1)
      Factory(:chunk_usage, page: @page, chunk: chunk2)
      attrs = {chunks_attributes: {
        "0" => {
          id: chunk1.id,
          position: 3
        },
        "1" => {
          id: chunk2.id,
          position: 1
        },
        "12345" => {
          type: "Chunks::BuiltIn::Html",
          content: "Valid content",
          title: "New!",
          position: 2,
          container_key: "main_content"
        }
      }} 
      @repository.update(@page.reload, attrs).should be_true
      @page.should have(3).chunks
      @page.chunks.first.title.should == "Second"
      @page.chunks.second.title.should == "New!"
      @page.chunks.third.title.should == "First"
      
      @page.save!
      @page.reload.should have(3).chunks
      @page.chunks.first.title.should == "Second"
      @page.chunks.second.title.should == "New!"
      @page.chunks.third.title.should == "First"
    end 
    
    it "reorders new chunks with validation errors" do
      existing = Factory(:chunk, title: "Existing")
      usage = Factory(:chunk_usage, page: @page, chunk: existing)
      attrs = {chunks_attributes: {
        "12345" => {
          type: "Chunks::BuiltIn::Html",
          content: "",
          title: "New!",
          container_key: "main_content",
          position: 1,
          _destroy: "0"          
        },
        "0" => {
          id: existing.id.to_s,
          position: 2,
          _destroy: "0"
        }
      }} 
      @repository.update(@page.reload, attrs).should be_false
      @page.chunks.first.title.should == "New!"
      @page.chunks.second.title.should == "Existing"
    end
    
   
    describe "including shared chunks" do    
      before(:each) do
        @shared = Factory(:shared_chunk)  
      end
   
      it "adds a usage to the correct container" do
        attrs = {chunks_attributes: { 
          "0" => {
            container_key: "main_content",
            id: @shared.chunk.id.to_s
          },
          "1" => {
            container_key: "sidebar",
            id: @shared.chunk.id.to_s
          },
        }}
        @repository.update(@page.reload, attrs).should be_true
        @page.reload
        @page.container(:main_content).should have(1).chunk
        @page.container(:sidebar).should have(1).chunk
      end
     
      it "is possible to include the same chunk multiple times" do
        2.times { Factory(:chunk_usage, page: @page, chunk: @shared.chunk) }
        attrs = {chunks_attributes: { "0" => {
          container_key: "main_content",
          id: @shared.chunk.id.to_s,
          position: "1"
        }, "1" => {
          container_key: "main_content",
          id: @shared.chunk.id.to_s,
          position: "2"
        }, "2" => {
          container_key: "main_content",
          id: @shared.chunk.id.to_s,
          position: "3"          
        }}}
        @repository.update(@page.reload, attrs).should be_true
        @page.container(:main_content).should have(3).chunks
        @page.container(:main_content).chunks.first.should === @page.container(:main_content).chunks.second
      end
      
      it "does not allow shared chunks to be updated" do
        attrs = {chunks_attributes: { "0" => {
          container_key: "content",
          id: @shared.chunk.id.to_s,
          position: "3",
          container_key: "sidebar",
          title: "ATTEMPTED UPDATE!"
        }}}
        @repository.update(@page.reload, attrs).should be_true
        chunk = @page.chunks.first
        chunk.container_key.should == :sidebar
        chunk.position.should == 3
        chunk.title.should_not == "ATTEMPTED UPDATE!"
      end
    end
    
    describe "chunks marked for deletion" do
      it "removes usages for existing chunks" do
        chunk = Factory(:chunk)
        usage = Factory(:chunk_usage, page: @page, chunk: chunk)
        attrs = {chunks_attributes: {"0" => {
          id: chunk.id,
          _destroy: "1"
        }}}
        @repository.update(@page.reload, attrs).should be_true
        @page.should have(0).chunks
        chunk.reload.should have(0).pages
      end
      
      it "does not persist new chunks" do
        attrs = {chunks_attributes: {
          "12345" => {
            type: "Chunks::BuiltIn::Html",
            content: "",
            title: "New!",
            container_key: "test_content",
            position: 1,
            _destroy: "1"
          }
        }}
        @repository.update(@page.reload, attrs).should be_true
        @page.should have(0).chunks
      end
    end
    
    describe "chunks marked for unsharing" do
      it "replaces the shared chunk with a clone" do
        shared = Factory(:shared_chunk)
        usage = Factory(:chunk_usage, page: @page, chunk: shared.chunk)
        attrs = {chunks_attributes: {"0" => {
          id: shared.chunk.id,
          _unshare: "1",
          container_key: "main_content"
        }}}
        @repository.update(@page.reload, attrs).should be_true
        @page.should have(1).chunks
        @page.chunks.first.should_not === shared.chunk
        @page.reload.chunks.first.should_not === shared.chunk
      end
    end
  end
end