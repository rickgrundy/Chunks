module Chunks
  class Chunk < ActiveRecord::Base
    belongs_to :page
    
    def self.title(title=nil)
      @title = title unless title.nil?
      @title || self.name.demodulize.titleize
    end
    
    def self.partial_name
      name.demodulize.underscore
    end
    
    def container_key
      read_attribute(:container_key).to_sym
    end
  end
end