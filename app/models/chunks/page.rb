module Chunks
  class Page < ActiveRecord::Base
    has_many :chunk_usages, order: :position, autosave: true
    has_many :chunks, through: :chunk_usages
    private :chunk_usages # External users should use #chunks which know about their usage context.
    accepts_nested_attributes_for :chunks, allow_destroy: true
    
    validates_associated :chunks, message: "are invalid (see below)"
    validates_presence_of :title, :template
    
    def template
      template_class = read_attribute(:template)
      template_class.is_a?(String) ? template_class.to_class : template_class
    end
    
    def containers
      @containers ||= template ? template.build_containers(self) : []
    end
    
    def container(key)
      containers.find { |c| c.key == key } || raise(Chunks::Error.new("#{template.title} pages do not have a container called '#{key}'"))
    end
    
    def chunks_attributes=(chunks_attrs)
      chunks_attrs.with_indifferent_access.values.each do |attrs|
        chunk = acquire_chunk(attrs)
        chunk.update_attributes(attrs.except(:id, :type, :_destroy))
        remove_chunk(chunk) if Boolean.parse(attrs[:_destroy])
        # chunk.usage_context.position_will_change!
      end
      chunk_usages.sort_by!(&:position)
    end
    
    def chunks
      # Don't reload from from DB, ensure modified instances remain.
      chunk_usages.map do |usage|
        chunk = usage.chunk
        chunk.usage_context = usage
        chunk
      end
    end
    
    def add_chunk(chunk, container_key)
      chunk_usages.build(chunk: chunk, container_key: container_key)
    end
    
    def remove_chunk(chunk)
      chunk.usage_context.destroy
      chunk_usages.delete(chunk.usage_context)
    end
    
    private
    
    def acquire_chunk(attrs)
      if attrs[:id]
        usage = chunks.find { |u| u.id == attrs[:id].to_i }
      else
        chunk = attrs[:type].to_class.new
        chunk.usage_context = chunk_usages.build(chunk: chunk)
        chunk
      end
    end
  end
end