FactoryGirl.define do
  factory :page, class: Chunks::Page do |page|
    page.title        { "Untitled Page" }
    page.template     { "Chunks::BuiltIn::Template::SingleColumn" }
    page.public       { true }
  end

  factory :two_column_page, parent: :page do |page|
    page.template { "Chunks::BuiltIn::Template::TwoColumn" }
  end
end