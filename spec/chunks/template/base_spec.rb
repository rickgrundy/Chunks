require File.expand_path("../../../spec_helper.rb", __FILE__)

describe Chunks::Template::Base do
  class Chunks::Template::TemplateWithTitle < Chunks::Template::Base
    title "An Exciting Title!"
  end
  class Chunks::Template::TemplateWithoutTitle < Chunks::Template::Base
  end
  
  it "allows a custom title to be provided" do        
    Chunks::Template::TemplateWithTitle.title.should == "An Exciting Title!"
    Chunks::Template::TemplateWithoutTitle.title.should == "Template Without Title"
  end
  
  it "provides an option for a select field" do
    Chunks::Template::TemplateWithTitle.option_for_select.should == ["An Exciting Title!", Chunks::Template::TemplateWithTitle]
  end
end