module Chunks
  class Chunk < ActiveRecord::Base
    include Chunks::ExtraAttributes
    include Chunks::SymbolizedAttributes

    has_many :chunk_usages
    has_many :pages, through: :chunk_usages
    delegate :container_key, :container_key=, :position, :position=, to: :usage_context
    
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
  end
end