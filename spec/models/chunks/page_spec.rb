require_relative "../../spec_helper.rb"

describe Chunks::Page do
  before(:each) do
    @repository = Chunks::PageRepository.new
  end
  
  it "exposes template as a class" do        
    Chunks::Page.new.template.should == nil
    Chunks::Page.new(template: Chunks::BuiltIn::Template::SingleColumn).template.should == Chunks::BuiltIn::Template::SingleColumn
    Chunks::Page.new(template: "Chunks::BuiltIn::Template::SingleColumn").template.should == Chunks::BuiltIn::Template::SingleColumn
  end
  
  describe "validation" do
    it "requires a title and template" do
      FactoryGirl.build(:page, title: nil).should_not be_valid
      FactoryGirl.build(:page, template: nil).should_not be_valid
    end
  end
  
  describe "managing containers" do
    it "returns an empty list of containers before a template has been set" do
      page = FactoryGirl.build(:page, template: nil)
      page.should have(0).containers
    end
    
    it "splits chunks into containers" do
      page = FactoryGirl.create(:two_column_page)    
      3.times { FactoryGirl.create(:chunk_usage, page: page, container_key: :main_content) }
      FactoryGirl.create(:chunk_usage, page: page, container_key: :sidebar)
    
      page.reload
      page.container(:main_content).should have(3).chunks
      page.container(:sidebar).should have(1).chunk
      
      page.save!
      page = Chunks::Page.find(page.id)
      
      page.container(:main_content).should have(3).chunks
      page.container(:sidebar).should have(1).chunk
    end
    
    it "sets each chunk's usage context" do
      page = FactoryGirl.create(:page)
      usage = FactoryGirl.create(:chunk_usage, page: page, position: 9)
      chunk = page.reload.container(:content).chunks.first
      chunk.usage_context.should == usage
    end
  end
end