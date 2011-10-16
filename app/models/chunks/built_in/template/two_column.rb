module Chunks::BuiltIn::Template
  class TwoColumn < Chunks::Template
    title "Two Column"
    container :main, "Main Content", Chunks::AllBuiltIns
    container :sidebar, "Sidebar", Chunks::AllBuiltIns
  end
end