module Chunks
  class SharedChunk < ActiveRecord::Base
    belongs_to :chunk
    accepts_nested_attributes_for :chunk
    validates_associated :chunk, message: "is invalid (see below)"
    
    validates_presence_of :name
    validates_uniqueness_of :name
    
    def unshare
      self.chunk.chunk_usages.to_a.from(1).each do |usage|
        usage.chunk = self.chunk.class.new(self.chunk.clone.attributes)
      end
      self.transaction { self.chunk.chunk_usages.each(&:save) && self.destroy }
    end
  end
end