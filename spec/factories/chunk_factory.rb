Factory.define :chunk, class: Chunks::BuiltIn::Text do |chunk|
  chunk.page          { Factory(:page) }
  chunk.container_key { :main }
  chunk.content       { "This is a Text Chunk" }
end