Factory.define :chunk, class: Chunks::BuiltIn::Text do |chunk|
  chunk.page          { Factory(:page) }
  chunk.container_key { :content }
  chunk.content       { "This is a Text Chunk" }
end