module Chunks
  class Page < ActiveRecord::Base
    has_many :chunk_usages, order: :position, autosave: true
    has_many :chunks, through: :chunk_usages
    private :chunk_usages # External users should always use #chunks.
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
    
    def update_all_chunks(attrs)
      self.attributes = attrs
      return false unless self.valid?
      self.transaction { self.save! && self.chunks.map(&:save!) }
      true
    end
    
    def chunks_attributes=(chunks_attrs)
      chunks_attrs.with_indifferent_access.values.each do |attrs|
        chunk = acquire_chunk(attrs)
        chunk.attributes = attrs.except(:id, :type, :_destroy)
        remove_chunk(chunk) if Boolean.parse(attrs[:_destroy])
      end
      chunk_usages.sort_by!(&:position)
    end
    
    def chunks
      chunk_usages.map do |usage|
        chunk = usage.chunk
        chunk.usage_context = usage
        chunk
      end
    end
    
    def add_chunk(chunk, container_key)
      usage = chunk_usages.build(chunk: chunk, container_key: container_key)
      chunk.usage_context = usage
    end
    
    def remove_chunk(chunk)
      chunk.usage_context.destroy
      chunk_usages.delete(chunk.usage_context)
    end
    
    private
    
    def acquire_chunk(attrs)
      if attrs[:id]
        chunk = chunks.find { |u| u.id == attrs[:id].to_i }
        if chunk.nil? # Newly included shared chunk
          chunk = Chunks::Chunk.find(attrs[:id])
          add_chunk(chunk, attrs[:container_key])
        end
      else
        chunk = attrs[:type].to_class.new
        chunk.usage_context = chunk_usages.build(chunk: chunk)
      end
      chunk
    end
  end
end