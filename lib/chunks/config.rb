module Chunks
  class Config
    attr_reader :templates
    
    def initialize
      @templates = []
      @chunks = {}
    end
    
    def chunks(group=:all)
      @chunks[group.to_sym] ||= []
    end
  end
end