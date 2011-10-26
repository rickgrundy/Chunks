require_relative "../../spec_helper.rb"

describe Chunks::ExtraAttributes do
  class Animal < Chunks::Chunk
    extra_attributes :breed, :colour
  end
  
  class Cat < Animal
    extra_attributes :fluffiness
    validates_presence_of :fluffiness
  end
  
  class LolCat < Chunks::Chunk
    extra_attributes :photo, :caption, :funny
  end
  
  
  describe "declaring and using extra attributes" do
    it "provides accessors for the extra attributes" do
      dog = Animal.new
      dog.breed = "Labrador"
      dog.colour = "Black"
    
      dog.breed.should == "Labrador"
      dog.colour.should == "Black"
    end
  
    it "allows additional attributes to be defined by child classes" do
      cat = Cat.new
      cat.breed = "Moggy"
      cat.fluffiness = "Very"
      
      cat.breed.should == "Moggy"
      cat.fluffiness.should == "Very"
    end
  end
  
  describe "ActiveRecord integration" do
    it "saves and retrieves attributes" do
      lolcat = LolCat.create!(photo: "A cat in the air", caption: "Invisible bike")
      lolcat.reload
      lolcat.photo.should == "A cat in the air"
      lolcat.caption.should == "Invisible bike"
    end
    
    it "updates attributes in bulk" do
      lolcat = LolCat.create!(photo: "A cat on a railing", caption: "Monorail cat is arriving", funny: false)
      lolcat.update_attributes!(caption: "Monorail cat has arrived", funny: true)      
      lolcat.reload
      lolcat.photo.should == "A cat on a railing"
      lolcat.caption.should == "Monorail cat has arrived"
      lolcat.funny.should be_true
    end
    
    it "validates like any other attribute" do
      Cat.new.should_not be_valid
      Cat.new(fluffiness: "Slightly").should be_valid
    end
    
    it "works with accepts_nested_attributes_for" do
      page = Factory(:page)
      chunk = Factory(:chunk, page: page)
      params = {"chunks_attributes" => {"0" => {
        "title" => "Click me",
         "css_class" => "expandable",
         "id" => chunk.id.to_s
      }}}
      page.reload
      page.update_attributes(params)
      page.chunks.first.title.should == "Click me"
      page.chunks.first.css_class.should == "expandable"
    end
  end
end