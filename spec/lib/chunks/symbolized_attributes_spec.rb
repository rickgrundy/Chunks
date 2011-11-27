require_relative "../../spec_helper.rb"

describe Chunks::SymbolizedAttributes do
  class CarAdvert < Chunks::Chunk
    extra_attributes :vehicle_manufacturer
    symbolized_attributes :vehicle_manufacturer, :not_an_attribute
  end
  
  it "always returns an ActiveRecord attribute as a symbol" do
    Chunks::ChunkUsage.new(container_key: "footer_ads").container_key.should == :footer_ads
  end
  
  it "always returns an ExtraAttribute attribute as a symbol" do
    CarAdvert.new(vehicle_manufacturer: "subaru").vehicle_manufacturer.should == :subaru
  end
  
  it "raises an error if there is not method or ActiveRecord method for the named attribute" do
    car_advert = CarAdvert.new
    -> { car_advert.not_an_attribute }.should raise_error(
      NoMethodError, "no attribute 'not_an_attribute' to symbolize for #{car_advert}"
    )
  end
end