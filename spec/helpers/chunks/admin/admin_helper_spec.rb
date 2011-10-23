require_relative "../../../spec_helper.rb"

describe Chunks::Admin::AdminHelper do
  describe "providing resource paths with a chunks_admin prefix for form helpers" do
    it "generates path for a new record" do
      page = Factory.build(:page)
      helper.chunks_admin_resource_path(page).should == "/chunks/admin/pages"
    end
    
    it "generates path for an existing record" do
      page = Factory(:page)
      helper.chunks_admin_resource_path(page).should == "/chunks/admin/pages/#{page.id}"
    end
  end
end