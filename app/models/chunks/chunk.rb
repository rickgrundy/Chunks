module Chunks
  class Chunk < ActiveRecord::Base
    include Chunks::ExtraAttributes
    belongs_to :page
    acts_as_list scope: [:page_id, :container_key]
    
    def self.title(title=nil)
      @title = title unless title.nil?
      @title || self.name.demodulize.titleize
    end
    
    def self.partial_name
      name.demodulize.underscore
    end
    
    def container_key
      container_key_attr = read_attribute(:container_key)
      container_key_attr.to_sym if container_key_attr
    end
  end
end