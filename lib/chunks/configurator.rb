module Chunks
  def self.configure(&config)
    Configurator.module_exec(&config)
  end
  
  module Configurator
    def self.template(*templates)
      templates = *templates.first if templates.first.is_a?(Array)
      templates.each do |template| 
        if template < Chunks::Template
          Chunks::AllTemplates << template
        else
          raise Chunks::Error.new("#{template.class} does not extend Chunks::Template.")
        end
      end
    end
  end
end