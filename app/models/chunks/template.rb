module Chunks
  class Template  
    def self.title(title=nil)
      @title = title unless title.nil?
      @title || self.name.demodulize.titleize
    end
    
    def self.view_name(view_name=nil)
      @view_name = view_name unless view_name.nil?
      @view_name || self.name.underscore
    end
    
    def self.container(key, title, *available_chunks)
      available_chunks = *available_chunks.first if available_chunks.first.is_a?(Array)
      @container_builders ||= []
      @container_builders << lambda { Chunks::Container.new(key, title, available_chunks) }
    end
  
    def self.build_containers(page)
      @container_builders.map do |builder|
        container = builder.call
        container.chunks = page.chunks.select { |c| c.container_key == container.key }
        container
      end
    end
  
    def self.option_for_select
      [self.title, self]
    end
  end
end