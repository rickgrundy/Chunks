module Chunks
  class Chunk < ActiveRecord::Base
    include Chunks::SymbolizedAttributes
    include Chunks::ExtraAttributes
    belongs_to :page
    acts_as_list scope: [:page_id, :container_key]
    symbolized_attributes :container_key
    
    def self.title(title=nil)
      @title = title unless title.nil?
      @title || self.name.demodulize.titleize
    end
    
    def self.partial_name
      name.demodulize.underscore
    end
  end
end