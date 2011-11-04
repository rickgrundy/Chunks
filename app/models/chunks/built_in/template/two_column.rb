module Chunks::BuiltIn::Template
  class TwoColumn < Chunks::Template
    title "Two Column"
    view_name "chunks/templates/two_column"
    container :main, "Main Content", Chunks.config.chunks(:built_in)
    container :sidebar, "Sidebar", Chunks.config.chunks(:built_in)
  end
end