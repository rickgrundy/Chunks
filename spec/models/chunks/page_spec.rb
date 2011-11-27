require_relative "../../spec_helper.rb"

describe Chunks::Page do
  it "exposes template as a class" do        
    Chunks::Page.new.template.should == nil
    Chunks::Page.new(template: Chunks::BuiltIn::Template::SingleColumn).template.should == Chunks::BuiltIn::Template::SingleColumn
    Chunks::Page.new(template: "Chunks::BuiltIn::Template::SingleColumn").template.should == Chunks::BuiltIn::Template::SingleColumn
  end
  
  describe "validation" do
    it "requires a title and template" do
      Factory.build(:page, title: nil).should_not be_valid
      Factory.build(:page, template: nil).should_not be_valid
    end
  end
  
  describe "managing containers" do
    it "returns an empty list of containers before a template has been set" do
      page = Factory.build(:page, template: nil)
      page.should have(0).containers
    end
    
    it "splits chunks into containers" do
      page = Factory(:two_column_page)    
      3.times { Factory(:chunk_usage, page: page, container_key: :main_content) }
      Factory(:chunk_usage, page: page, container_key: :sidebar)
    
      page.reload
      page.container(:main_content).should have(3).chunks
      page.container(:sidebar).should have(1).chunk
      
      page.save!
      page = Chunks::Page.find(page.id)
      
      page.container(:main_content).should have(3).chunks
      page.container(:sidebar).should have(1).chunk
    end
  end
  
  describe "updating chunks via nested attributes" do
    before(:each) do
      @page = Factory(:page)
    end
    
    it "updates existing chunks" do
      usage = Factory(:chunk_usage, page: @page)
      attrs = {chunks_attributes: { "0" => {
        type: "Chunks::BuiltIn::Html",
        title: "Updated!",
        id: usage.chunk.id.to_s
      }}}
      @page.reload.update_attributes(attrs)
      @page.should have(1).chunk
      @page.chunks.first.title.should == "Updated!"
    end
    
    it "creates new chunks of specified type" do
      attrs = {chunks_attributes: { "0" => {
        type: "Chunks::BuiltIn::Html",
        content: "Valid content",
        title: "New!",
        container_key: "test_content",
        position: "1"
      }}}
      @page.reload.update_attributes(attrs)
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
          container_key: "test_content"
        }
      }} 
      @page.reload.update_attributes(attrs).should be_true
      @page.should have(3).chunks
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
          container_key: "test_content",
          position: 1,
          _destroy: "0"          
        },
        "0" => {
          id: existing.id.to_s,
          position: 2,
          _destroy: "0"
        }
      }} 
      @page.reload.update_attributes(attrs).should be_false
      @page.chunks.first.title.should == "New!"
      @page.chunks.second.title.should == "Existing"
    end
    
    it "removes usages for existing chunks" do
      chunk = Factory(:chunk)
      usage = Factory(:chunk_usage, page: @page, chunk: chunk)
      @page.reload.update_attributes(
        chunks_attributes: {"0" => {
          id: chunk.id,
          _destroy: "1"
        }})
      @page.should have(0).chunk_usages
    end
  end
end