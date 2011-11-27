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
  
  it "raises an error if a container which does not exist is requested" do
    -> { Factory(:page).container(:not_real) }.should raise_error Chunks::Error
  end
  
  it "acts as list within its page and container" do
    our_page = Factory(:page)
    someone_elses_page = Factory(:page)    
    3.times do 
      Factory(:chunk_usage, page: our_page, container_key: :content)
      Factory(:chunk_usage, page: our_page, container_key: :other)
      Factory(:chunk_usage, page: someone_elses_page, container_key: :content)
    end
    our_page.reload
    our_page.chunk_usages.where(container_key: :content).first.position.should == 1
    our_page.chunk_usages.where(container_key: :content).second.position.should == 2
    our_page.chunk_usages.where(container_key: :content).third.position.should == 3
  end
end