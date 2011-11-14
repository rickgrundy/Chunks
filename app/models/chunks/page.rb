module Chunks
  class Page < ActiveRecord::Base
    has_many :chunks, order: :position
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
      chunks_attrs.values.each do |attrs|
        chunk = acquire_chunk(attrs)
        chunk.update_attributes(attrs.except(:type, :id, :_destroy))
        chunk.destroy if Boolean.parse(attrs[:_destroy])
      end
      chunks.sort_by!(&:position)
    end
    
    private
    
    def acquire_chunk(attrs)
      if attrs[:id]
        return chunks.find(attrs[:id])
      else
        chunk = attrs[:type].to_class.new(page: self)
        chunks << chunk
        return chunk
      end
    end
  end
end