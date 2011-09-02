module Chunks::Template 
  class Base    
    def self.container(key, title, *available_chunks)
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
    
    def self.title(title=nil)
      @title = title unless title.nil?
      @title || self.name.demodulize.titleize
    end
    
    def self.option_for_select
      [self.title, self]
    end
  end
end