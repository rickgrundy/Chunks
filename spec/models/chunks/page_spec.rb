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
      3.times { Factory(:chunk, page: page, container_key: :main_content) }
      Factory(:chunk, page: page, container_key: :sidebar)
    
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
      chunk = Factory(:chunk, page: @page)
      attrs = {chunks_attributes: { "0" => {
        type: "Chunks::BuiltIn::Html",
        title: "Updated!",
        id: chunk.id
      }}}
      @page.reload.should have(1).chunk
      @page.update_attributes(attrs)
      @page.reload.should have(1).chunk
      chunk.reload.title.should == "Updated!"
    end
    
    it "creates new chunks of specified type" do
      attrs = {chunks_attributes: { "0" => {
        type: "Chunks::BuiltIn::Html",
        content: "Valid content",
        title: "New!"
      }}}
      @page.update_attributes(attrs)
      @page.reload.should have(1).chunk
      @page.chunks.first.should be_a Chunks::BuiltIn::Html
      @page.chunks.first.title.should == "New!"
    end   
    
    it "reorders chunks" do
      chunk1 = Factory(:chunk, page: @page, title: "First")
      chunk2 = Factory(:chunk, page: @page, title: "Second")
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
          position: 2
        }
      }} 
      @page.update_attributes(attrs)
      reordered = @page.reload.chunks
      reordered.first.title.should == "Second"
      reordered.second.title.should == "New!"
      reordered.third.title.should == "First"
    end 
  end
end