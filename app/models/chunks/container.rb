module Chunks
  class Container
    attr_reader :key, :title, :available_chunks
    attr_accessor :chunks
    
    def initialize(key, *available_chunks)
      begin
        @key = key.to_sym
      rescue NoMethodError
        raise Chunks::Error.new("Container key must be a symbol") 
      end
      @title = key.to_s.humanize.titlecase
      
      available_chunks = *available_chunks.first if available_chunks.first.is_a?(Array)
      available_chunks.each do |ac| 
        raise Chunks::Error.new("#{ac.inspect} is not a class") unless ac.is_a?(Class)
      end
      @available_chunks = available_chunks
      @chunks = []
    end
    
    def valid_chunks
      @chunks.select(&:valid?)
    end
  end
end