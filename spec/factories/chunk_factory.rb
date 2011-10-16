Factory.define :chunk, class: Chunks::BuiltIn::Html do |chunk|
  chunk.container_key { :main }
  chunk.content       { "<h1>This is an HTML Chunk</h1>" }
end
