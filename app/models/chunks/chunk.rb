module Chunks
  class Chunk < ActiveRecord::Base
    include Chunks::ExtraAttributes
    include Chunks::SymbolizedAttributes

    has_many :chunk_usages
    has_many :chunks, through: :chunk_usages
    
    def self.title(title=nil)
      @title = title unless title.nil?
      @title || self.name.demodulize.titleize
    end
    
    def self.partial_name
      self.name.demodulize.underscore
    end
    
    def previewable?
      true
    end
  end
end