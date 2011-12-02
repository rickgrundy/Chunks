module Chunks
  class Chunk < ActiveRecord::Base
    include Chunks::ExtraAttributes
    include Chunks::SymbolizedAttributes

    has_many :chunk_usages
    has_many :pages, through: :chunk_usages
    delegate :container_key, :container_key=, :position, :position=, to: :usage_context
    
    has_one :shared_chunk
    
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
    
    def usage_context=(chunk_usage)
      @usage_context = chunk_usage
    end
    
    def usage_context
      @usage_context || raise(Chunks::Error.new("Attempted to refer to usage context which has not been set."))
    end
    
    def share(shared_name)
      if shared?
        shared_chunk
      else
        create_shared_chunk(name: shared_name)
      end
    end
    
    def shared?
      shared_chunk.present?
    end
    
    def _unshare
      false
    end
  end
end