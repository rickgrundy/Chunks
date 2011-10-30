module Chunks::BuiltIn::Template
  class TwoColumn < Chunks::Template
    title "Two Column"
    view_name "chunks/templates/two_column"
    container :main, "Main Content", Chunks::AllBuiltIns
    container :sidebar, "Sidebar", Chunks::AllBuiltIns
  end
end