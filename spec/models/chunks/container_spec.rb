require_relative "../../spec_helper.rb"

describe Chunks::Container do
  describe "configuring with available chunks" do
    it "accepts available chunks as an array or varargs" do
      Chunks::Container.new(:test_container, Chunks::BuiltIn::Text, Chunks::BuiltIn::Html).available_chunks.size.should == 2
      Chunks::Container.new(:test_container, [Chunks::BuiltIn::Text, Chunks::BuiltIn::Html]).available_chunks.size.should == 2
    end
  
    it "raises an error if a key is not provided" do
      -> { Chunks::Container.new(*Chunks.config.chunks(:all)) }.should raise_error Chunks::Error
    end
  
    it "raises an error if something other than an available chunk is provided" do
      -> { Chunks::Container.new(:test_container, "Not", "Chunks") }.should raise_error Chunks::Error
    end
  end
  
  it "provides a readable title" do
    Chunks::Container.new(:test_container, *Chunks.config.chunks(:all)).title.should == "Test Container"
  end
  
  it "provides a list of valid chunks for rendering" do
    container = Chunks::Container.new(:test_container, Chunks.config.chunks(:all))
    container.chunks << valid_chunk = Factory.build(:chunk)
    container.chunks << invalid_chunk = Factory.build(:chunk, content: nil)
    container.valid_chunks.should include valid_chunk
    container.valid_chunks.should_not include invalid_chunk
  end
end