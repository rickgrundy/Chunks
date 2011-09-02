module Chunks::Template
  class TwoColumn < Base
    title "Two Column"
    container :main, "Main Content", Chunks::Html, Chunks::Text
    container :sidebar, "Sidebar", Chunks::Html, Chunks::Text
  end
end