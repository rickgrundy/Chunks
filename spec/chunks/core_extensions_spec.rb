require File.expand_path("../../spec_helper.rb", __FILE__)

describe "Chunks Core Extensions" do  
  describe "for String" do
    it "returns a class without module" do        
      "Array".to_class.should == Array
    end
    
    it "returns a modulised class" do
      "Chunks::Template::Base".to_class.should == Chunks::Template::Base
    end
  end
end