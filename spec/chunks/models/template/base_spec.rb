require File.expand_path("../../../../spec_helper.rb", __FILE__)

describe Chunks::Template::Base do
  class Chunks::Template::WithTitle < Chunks::Template::Base
    title "An Exciting Title!"
  end
  
  class Chunks::Template::WithoutTitle < Chunks::Template::Base
  end
  
  class Chunks::Template::TwoContainers < Chunks::Template::Base
    container :first, "Container 1", Chunks::Html, Chunks::Text
    container :second, "Container 2", Chunks::Html
  end
  
  
  it "allows a custom title to be provided" do        
    Chunks::Template::WithTitle.title.should == "An Exciting Title!"
    Chunks::Template::WithoutTitle.title.should == "Without Title"
  end
  
  it "renders itself as an option for a select field" do
    Chunks::Template::WithTitle.option_for_select.should == ["An Exciting Title!", Chunks::Template::WithTitle]
  end
  
  it "allows provides containers to pages which use the template" do
    page = Factory(:page, template: "Chunks::Template::TwoContainers")
    page.should have(2).containers
    
    page.containers[0].key.should == :first
    page.containers[0].title.should == "Container 1"
    page.containers[0].available_chunks.should == [Chunks::Html, Chunks::Text]
    
    page.containers[1].key.should == :second
    page.containers[1].title.should == "Container 2"
    page.containers[1].available_chunks.should == [Chunks::Html]
  end
end