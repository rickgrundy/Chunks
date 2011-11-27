module Chunks
  class ChunkUsage < ActiveRecord::Base
    include Chunks::SymbolizedAttributes
    
    belongs_to :page
    belongs_to :chunk
    
    acts_as_list scope: [:page_id, :container_key]
    
    symbolized_attributes :container_key
  end
end