module Chunks
  class Chunk < ActiveRecord::Base
    def self.title(title=nil)
      @title = title unless title.nil?
      @title || self.name.demodulize.titleize
    end
    
    def container_key
      read_attribute(:container_key).to_sym
    end
  end
end