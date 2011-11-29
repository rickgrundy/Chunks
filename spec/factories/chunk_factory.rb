Factory.define :chunk, class: Chunks::BuiltIn::Text do |chunk|
  chunk.content       { "This is a Text Chunk" }
end

Factory.define(:text_chunk, parent: :chunk, class: Chunks::BuiltIn::Text) {}
Factory.define(:html_chunk, parent: :chunk, class: Chunks::BuiltIn::Html) {}
Factory.define(:markdown_chunk, parent: :chunk, class: Chunks::BuiltIn::MarkdownWiki) {}

Factory.define :chunk_usage, class: Chunks::ChunkUsage do |usage|
  usage.chunk         { Factory(:chunk) }
  usage.page          { Factory(:page) }
  usage.container_key { :content }
end

Factory.sequence(:shared_count)
Factory.define :shared_chunk, class: Chunks::SharedChunk do |shared|
  shared.chunk  { Factory(:chunk) }
  shared.name   { "Factory shared ##{Factory.next(:shared_count)}" }
end