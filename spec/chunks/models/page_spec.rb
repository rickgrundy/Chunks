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
  
  it "splits chunks into containers" do
    page = Factory(:two_column_page)
    
    3.times { page.chunks << Factory(:chunk, container_key: :main) }
    page.chunks << Factory(:chunk, container_key: :sidebar)
    
    page.container(:main).should have(3).chunks
    page.container(:sidebar).should have(1).chunk
  end
end