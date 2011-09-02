Factory.define :page, class: Chunks::Page do |page|
  page.title        { "Untitled Page" }
  page.template     { "Chunks::Template::SingleColumn" }
  page.public       { true }
end

Factory.define :two_column_page, parent: :page do |page|
  page.template { "Chunks::Template::TwoColumn" }
end