module Chunks::BuiltIn::Template
  class SingleColumn < Chunks::Template
    title "Single Column"
    view_name "chunks/templates/single_column"
    container :main, "Content", Chunks::AllBuiltIns
  end
end