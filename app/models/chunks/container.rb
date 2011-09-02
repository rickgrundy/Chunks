module Chunks
  class Container
    attr_reader :key, :title, :available_chunks
    attr_accessor :chunks
    
    def initialize(key, title, available_chunks)
      @key = key
      @title = title
      @available_chunks = available_chunks
      @chunks = []
    end
  end
end