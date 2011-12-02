require_relative "../../spec_helper.rb"

describe Chunks::SharedChunk do
  describe "validation of name" do
    it "is required" do
      Factory.build(:shared_chunk, name: "").should_not be_valid
    end
    
    it "must be unique" do
      Factory(:shared_chunk, name: "Name!").should be_valid
      Factory.build(:shared_chunk, name: "Name!").should_not be_valid
    end
  end
  
  describe "unsharing" do
    before(:each) do
      @shared_chunk = Factory(:shared_chunk)
    end
    
    it "destroys itself" do
      @shared_chunk.unshare
      @shared_chunk.should be_destroyed
    end
  end
end