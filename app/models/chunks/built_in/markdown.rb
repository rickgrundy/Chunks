require 'bluecloth'

module Chunks::BuiltIn
  class Markdown < Text
    title "Markdown (wiki)"
    
    def render_markdown
      BlueCloth.new(content).to_html
    end
  end
end