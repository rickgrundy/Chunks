require File.expand_path("../../spec_helper.rb", __FILE__)

describe Chunks::Template do
  class TemplateOne; end
  class TemplateTwo; end
  class TemplateThree; end
  
  it "allows templates to be registered" do        
    Chunks::Template.add TemplateOne
    Chunks::Template.all.should include TemplateOne
    
    Chunks::Template.add TemplateTwo, TemplateThree
    Chunks::Template.all.should include TemplateOne, TemplateTwo, TemplateThree
  end
end