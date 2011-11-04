module Chunks
  class Config
    attr_reader :templates, :extensions
    
    def initialize
      @templates = []
      @chunks = {}
      @extensions = []
    end
    
    def chunks(group=:all)
      @chunks[group.to_sym] ||= []
    end
  end
end