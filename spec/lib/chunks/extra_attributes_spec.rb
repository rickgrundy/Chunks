require_relative "../../spec_helper.rb"

describe Chunks::ExtraAttributes do
  class Animal < Chunks::Chunk
    extra_attributes :breed, :colour
    extra_boolean_attributes :is_a_fish
  end
  
  class Cat < Animal
    extra_attributes :fluffiness
    validates_presence_of :fluffiness
  end
  
  class LolCat < Animal
    extra_attributes :photo, :caption, :funny
    extra_attributes(:shout) { |val| val.upcase + "!!!" }
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
  
  it "allows a translator block to be provided" do
    lolcat = LolCat.new(shout: "ohai")
    lolcat.shout.should == "OHAI!!!"
  end
  
  describe "extra boolean attributes" do
    it "treats '1' as true" do
      shark = Animal.new(is_a_fish: "1")
      shark.is_a_fish.should be_true
    end
    
    it "treats '0' as false" do
      dolphin = Animal.new(is_a_fish: "0")
      dolphin.is_a_fish.should_not be_true
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
  end
end