Chunks.configure do
  chunk Chunks::BuiltIn::Text, Chunks::BuiltIn::Html, Chunks::BuiltIn::MarkdownWiki, group: "built_in"
  template Chunks::BuiltIn::Template::SingleColumn, Chunks::BuiltIn::Template::TwoColumn
end