module Chunks::BuiltIn
  class MarkdownWiki < Text
    title "Markdown (wiki syntax)"
    
    def render_markdown
      Redcarpet.new(content).to_html
    end
  end
end