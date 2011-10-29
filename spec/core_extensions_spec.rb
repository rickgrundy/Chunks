require_relative "spec_helper.rb"

describe "Chunks Core Extensions" do  
  describe "for String" do
    it "returns a class without module" do        
      "Array".to_class.should == Array
    end
    
    it "returns a modulised class" do
      "Chunks::BuiltIn::Html".to_class.should == Chunks::BuiltIn::Html
    end
  end
  
  describe "for Boolean" do    
    it "parses common representations of true" do
      [1, "1", "true", "t", "TRUE", "T", "yes", "YES", "y", "Y"].each do |val|
        Boolean.parse(val).should be_true
      end
    end
    
    it "parses anything else as false" do
      [0, "0", 2, "2", "false", "badger"].each do |val|
        Boolean.parse(val).should be_false
      end
    end
  end
end