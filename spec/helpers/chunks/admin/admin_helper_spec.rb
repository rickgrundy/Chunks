require_relative "../../../spec_helper.rb"

describe Chunks::Admin::AdminHelper do
  describe "rendering validation errors" do
    before(:each) do
      @untitled_page = Factory.build(:page)
      @untitled_page.title = nil
    end
    
    it "does not render anything if model is valid" do
      helper.validation_errors(Factory(:page)).should be_nil
    end
    
    it "does not render anything if model has not been validated" do
      helper.validation_errors(@untitled_page).should be_nil
    end
    
    it "renders the errors partial if model is invalid" do
      @untitled_page.valid?
      content = helper.validation_errors(@untitled_page)
      content.should include "Title can't be blank"
    end
    
    it "accepts a custom title" do
      @untitled_page.valid?
      content = helper.validation_errors(@untitled_page, "Disaster!")
      content.should include "Disaster!"
    end
    
    it "uses a default title if not specified" do
      @untitled_page.valid?
      content = helper.validation_errors(@untitled_page)
      content.should include "Page could not be saved"
    end
  end
end