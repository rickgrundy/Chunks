module Chunks
  class Page < ActiveRecord::Base
    has_many :chunks
    accepts_nested_attributes_for :chunks
    validates_associated :chunks
    validates_presence_of :title, :template
    
    def template
      template_class = read_attribute(:template)
      template_class.is_a?(String) ? template_class.to_class : template_class
    end
    
    def containers
      @containers ||= template.build_containers(self)
    end
    
    def container(key)
      containers.find { |c| c.key == key }
    end
  end
end