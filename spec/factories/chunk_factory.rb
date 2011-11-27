Factory.define :chunk, class: Chunks::BuiltIn::Text do |chunk|
  chunk.content       { "This is a Text Chunk" }
end

Factory.define :chunk_usage, class: Chunks::ChunkUsage do |usage|
  usage.chunk         { Factory(:chunk) }
  usage.page          { Factory(:page) }
  usage.container_key { :content }
end

Factory.define :shared_chunk, class: Chunks::SharedChunk do |shared|
  shared.chunk  { Factory(:chunk) }
  shared.name   { "Shared from factory" }
end