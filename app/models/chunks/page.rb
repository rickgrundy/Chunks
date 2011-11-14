module Chunks
  class Page < ActiveRecord::Base
    has_many :chunks, order: :position
    accepts_nested_attributes_for :chunks
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
        if attrs[:id]
          chunk = self.chunks.find(attrs[:id])
        else
          chunk = attrs[:type].to_class.new(page: self)
          self.chunks << chunk
        end
        chunk.update_attributes(attrs.except(:type, :id))
      end
      chunks.sort_by!(&:position)
    end
  end
end