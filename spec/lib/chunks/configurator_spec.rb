require File.expand_path("../../../spec_helper.rb", __FILE__)

describe Chunks::Configurator do  
  class MyTemplate1 < Chunks::Template; end
  class MyTemplate2 < Chunks::Template; end
  class MyTemplate3 < Chunks::Template; end
  class MyTemplate4 < Chunks::Template; end
  class MyTemplate5 < Chunks::Template; end
  
  describe "registering templates" do
    it "allows templates to be registered" do
      Chunks.configure do 
        template MyTemplate1
        template MyTemplate2, MyTemplate3
        template [MyTemplate4, MyTemplate5]
      end
      Chunks::AllTemplates.should include MyTemplate1, MyTemplate2, MyTemplate3, MyTemplate4, MyTemplate5
    end
    
    it "only allows subclasses of Chunks::Template" do
      -> { Chunks.configure { template String } }.should raise_error Chunks::Error
    end
  end
end