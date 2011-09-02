module Chunks::Template
  class SingleColumn < Base
    title "Single Column"
    container :main, "Content", Chunks::Html, Chunks::Text
  end
end