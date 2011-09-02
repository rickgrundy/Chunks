module Chunks::Admin::AdminHelper
  def title(text)
    content_for(:page_title, text)
    content_for(:browser_title, "#{text} - #{Rails.application.class.parent_name} Chunks Admin")
  end
end