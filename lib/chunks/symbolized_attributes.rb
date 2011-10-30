module Chunks::SymbolizedAttributes
  def self.included(klass)
    klass.extend(ClassMethods)
  end
  
  module ClassMethods
    def symbolized_attributes(*attrs)
      attrs.each do |attr|
        if method_defined?(attr)
          symbolize_attribute_method(attr)
        else
          symbolize_activerecord_reader(attr)
        end
      end
    end
    
    def symbolize_attribute_method(attr)
      alias_method "_#{attr}", attr
      define_method(attr) do
        val = send("_#{attr}")
        val.to_sym if val
      end
    end
    
    def symbolize_activerecord_reader(attr)
      define_method(attr) do
        if attribute_method?(attr.to_s)
          val = read_attribute(attr)
          val.to_sym if val
        else
          raise NoMethodError.new("no attribute '#{attr}' to symbolize for #{self}")
        end
      end
    end
  end
end