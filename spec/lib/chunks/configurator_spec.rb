require_relative "../../spec_helper.rb"

describe Chunks::Configurator do  
  class MyTemplate1 < Chunks::Template; end
  class MyTemplate2 < Chunks::Template; end
  class MyTemplate3 < Chunks::Template; end
  class MyTemplate4 < Chunks::Template; end
  class MyTemplate5 < Chunks::Template; end
  
  class MyChunk1 < Chunks::Chunk; end
  class MyChunk2 < Chunks::Chunk; end
  class MyChunk3 < Chunks::Chunk; end
  class MyChunk4 < Chunks::Chunk; end
  class MyChunk5 < Chunks::Chunk; end
  
  describe "registering templates" do
    it "allows templates to be registered" do
      Chunks.configure do 
        template MyTemplate1
        template MyTemplate2, MyTemplate3
        template [MyTemplate4, MyTemplate5]
      end
      Chunks.config.templates.should include MyTemplate1, MyTemplate2, MyTemplate3, MyTemplate4, MyTemplate5
    end
    
    it "only allows subclasses of Chunks::Template" do
      -> { Chunks.configure { template String } }.should raise_error Chunks::Error
    end
  end
  
  describe "registering chunks" do
    it "registers chunks in the default :all group" do
      Chunks.configure do
        chunk MyChunk1
        chunk MyChunk2, MyChunk3
        chunk [MyChunk4, MyChunk5]
      end
      Chunks.config.chunks.should include MyChunk1, MyChunk2, MyChunk3, MyChunk4, MyChunk5
    end
    
    describe "with a specified group" do 
      it "is optional to specify a group" do
        Chunks.configure do
          chunk MyChunk1, group: "built_in"
          chunk MyChunk2, MyChunk3, group: "built_in"
          chunk MyChunk4
        end
        Chunks.config.chunks("built_in").should include MyChunk1, MyChunk2, MyChunk3
        Chunks.config.chunks(:built_in).should_not include MyChunk4
      end
    
      it "also registers chunks in the default :all group" do
        Chunks.configure do
          chunk MyChunk1, group: "built_in"
        end
        Chunks.config.chunks.should include MyChunk1
      end
      
      it "allows chunks to be registered in multiple groups" do
        Chunks.configure do
          chunk MyChunk1, group: "group_a"
          chunk MyChunk1, group: "group_b"
        end
        Chunks.config.chunks("group_a").should include MyChunk1
        Chunks.config.chunks("group_b").should include MyChunk1
        Chunks.config.chunks("group_c").should_not include MyChunk1
      end
    end
    
    it "only allows subclasses of Chunks::Chunk" do
      -> { Chunks.configure { chunk String } }.should raise_error Chunks::Error
    end
  end
  
  describe "defining and setting options" do
    it "allows options to be defined by other engines" do
      Chunks.configure do
        option :test_storage_type
        option :test_s3_key, :test_s3_secret
        option [:test_s3_region, :test_s3_bucket]
        set :test_storage_type, "S3"
        set :test_s3_secret, "SECRET"
        set :test_s3_bucket, "BUCKET"
      end
      Chunks.config.test_storage_type.should == "S3"
      Chunks.config.test_s3_secret.should == "SECRET"
      Chunks.config.test_s3_bucket.should == "BUCKET"
    end
    
    it "allows options to be overridden" do
      Chunks.configure do
        option :badger
        set :badger, "Mushroom"
        set :badger, "Snake"
      end
      Chunks.config.badger.should == "Snake"
    end
    
    it "allows a default to be specified and overridden" do
      Chunks.configure { option :car, default: "Lotus" }
      Chunks.config.car.should == "Lotus"
      Chunks.configure { set :car, "Austin Healey" }
      Chunks.config.car.should == "Austin Healey"
    end
    
    it "does not allow undefined options to be set" do
      -> { Chunks.configure { set :not_defined, true } }.should raise_error Chunks::Error
    end
  end
  
  describe "registering extensions" do
    it "allows extensions such as chunks-mediapack to register their presence" do
      Chunks.configure do
        extension "mediapack"
        extension "socialpack"
      end
      Chunks.config.extensions.should include "mediapack", "socialpack"
    end
  end
end