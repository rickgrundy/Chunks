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
end