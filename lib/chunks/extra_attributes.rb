module Chunks::ExtraAttributes
  def self.included(klass)
    klass.serialize :extra_attributes, Hash
    klass.extend(ClassMethods)
  end
  
  module ClassMethods
    def extra_attributes(*attrs)
      attrs.each do |attr|
        define_method("#{attr}=") do |val| 
          extra_attributes[attr] = val
          extra_attributes_will_change!
        end  
        define_method(attr) do
          extra_attributes[attr]
        end
      end
    end
  end
end