Factory.define :chunk, class: Chunks::BuiltIn::Text do |chunk|
  chunk.content       { "This is a Text Chunk" }
end

Factory.define :chunk_usage, class: Chunks::ChunkUsage do |usage|
  usage.chunk         { Factory(:chunk) }
  usage.page          { Factory(:page) }
  usage.container_key { "factory_content" }
end