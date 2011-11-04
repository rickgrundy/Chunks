module Chunks
  def self.config
    @config ||= Chunks::Config.new
  end
  
  def self.configure(&config)
    Configurator.module_exec(&config)
  end
  
  module Configurator
    def self.template(*templates)
      templates = *templates.first if templates.first.is_a?(Array)
      templates.each do |template| 
        if template < Chunks::Template
          Chunks.config.templates << template
        else
          raise Chunks::Error.new("#{template.class} does not extend Chunks::Template.")
        end
      end
    end
    
    def self.chunk(*chunks)
      chunks = *chunks.first if chunks.first.is_a?(Array)
      opts = chunks.last.is_a?(Hash) ? chunks.pop : {}
      chunks.each do |chunk| 
        if chunk < Chunks::Chunk
          Chunks.config.chunks(:all) << chunk
          Chunks.config.chunks(opts[:group]) << chunk if opts[:group]
        else
          raise Chunks::Error.new("#{chunk.class} does not extend Chunks::Chunk.")
        end
      end
    end
    
    def self.option(*options)
      options = *options.first if options.first.is_a?(Array)
      opts = options.last.is_a?(Hash) ? options.pop : {}
      options.each do |option|
        Chunks.config.class.send(:attr_reader, option)
        set(option, opts[:default]) if opts[:default]
      end
    end
    
    def self.set(option, value)
      if Chunks.config.methods.include?(option)
        Chunks.config.instance_variable_set("@#{option}", value)
      else
        raise Chunks::Error.new("Could not set #{option} as it has not been defined as an option.")
      end
    end
    
    def self.extension(name)
      Chunks.config.extensions << name
    end
  end
end