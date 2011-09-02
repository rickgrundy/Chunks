require File.expand_path("../../../spec_helper.rb", __FILE__)

describe Chunks::Page do
  it "exposes template as a class" do        
    Chunks::Page.new(template: "Chunks::Template::SingleColumn").template.should == Chunks::Template::SingleColumn
  end
end