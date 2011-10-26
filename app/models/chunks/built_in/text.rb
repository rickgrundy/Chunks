module Chunks::BuiltIn
  class Text < Chunks::Chunk
    title "Pre-formatted Text"
    extra_attributes :accordion, :css_class
    
    validates :content, presence: true
    validates :title, presence: {:if => :accordion }
  end
end