module Chunks::BuiltIn
  class Text < Chunks::Chunk
    title "Pre-formatted Text"
    extra_attributes :css_class
    extra_boolean_attributes :expandable
    
    validates :content, presence: true
    validates :title, presence: {:if => :expandable, message: "can't be blank if content is expandable"} 
  end
end