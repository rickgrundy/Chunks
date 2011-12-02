module Chunks
  class ChunkUsage < ActiveRecord::Base
    include Chunks::SymbolizedAttributes
    
    belongs_to :page
    belongs_to :chunk
    
    acts_as_list scope: [:page_id, :container_key]
    
    symbolized_attributes :container_key
    
    def unshare
      self.chunk = self.chunk.class.new(self.chunk.attributes.with_indifferent_access.except(:id, :type))
      self.chunk.usage_context = self
      self.chunk
    end
  end
end