require_relative "../../spec_helper.rb"

describe Chunks::Chunk do
  class Chunks::Chunk::WithTitle < Chunks::Chunk
    title "An Exciting Title!"
  end
  
  class Chunks::Chunk::WithoutTitle < Chunks::Chunk
  end
  
  it "allows a custom title to be provided" do        
    Chunks::Chunk::WithTitle.title.should == "An Exciting Title!"
    Chunks::Chunk::WithoutTitle.title.should == "Without Title"
  end
  
  it "provides a template name for render partial" do
    Chunks::Chunk::WithTitle.partial_name.should == "with_title"
  end
end