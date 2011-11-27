module Chunks
  class Page < ActiveRecord::Base
    has_many :chunk_usages, order: :position
    has_many :chunks, through: :chunk_usages
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
        usage = acquire_chunk_usage(attrs)
        
        usage.chunk.update_attributes(attrs.except(*Chunks::ChunkUsage.attribute_names, :id, :type, :_destroy))
      
        if usage.new_record?
          usage.attributes = attrs.slice(*Chunks::ChunkUsage.attribute_names)
        else
          if Boolean.parse(attrs[:_destroy])
            usage.destroy
            self.chunk_usages.delete(usage)
          else
            usage.update_attributes(attrs.slice(*Chunks::ChunkUsage.attribute_names))
          end
        end
      end
      chunk_usages.sort_by!(&:position)
    end
    
    def chunks
      self.chunk_usages.map(&:chunk) # Don't reload from from DB, ensure modified instances remain.
    end
    
    private
    
    def acquire_chunk_usage(attrs)
      if attrs[:id]
        # Doing a .where would load single usage from DB. A different instance would later be returned by .chunks. 
        usage = self.chunk_usages.to_a.find { |u| u.chunk_id == attrs[:id].to_i }
      else
        self.chunk_usages.build(chunk: attrs[:type].to_class.new)
      end
    end
  end
end