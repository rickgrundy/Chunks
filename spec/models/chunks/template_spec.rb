require_relative "../../spec_helper.rb"

describe Chunks::Template do
  class Chunks::Template::WithTitle < Chunks::Template
    title "An Exciting Title!"
  end
  
  class Chunks::Template::WithoutTitle < Chunks::Template
  end
  
  class Chunks::Template::TwoContainers < Chunks::Template
    container :first, "Container 1", Chunks::BuiltIn::Html, Chunks::BuiltIn::Text
    container :second, "Container 2", [Chunks::BuiltIn::Text, Chunks::BuiltIn::Html]
  end
  
  it "allows a custom title to be provided" do        
    Chunks::Template::WithTitle.title.should == "An Exciting Title!"
    Chunks::Template::WithoutTitle.title.should == "Without Title"
  end
  
  it "renders itself as an option for a select field" do
    Chunks::Template::WithTitle.option_for_select.should == ["An Exciting Title!", Chunks::Template::WithTitle]
  end
  
  it "provides containers to pages which use the template" do
    page = Factory(:page, template: "Chunks::Template::TwoContainers")
    page.should have(2).containers
    
    page.containers.first.key.should == :first
    page.containers.first.title.should == "Container 1"
    page.containers.first.available_chunks.should == [Chunks::BuiltIn::Html, Chunks::BuiltIn::Text]
    
    page.containers.second.key.should == :second
    page.containers.second.title.should == "Container 2"
    page.containers.second.available_chunks.should == [Chunks::BuiltIn::Text, Chunks::BuiltIn::Html]
  end
end