module Chunks::Admin::AdminHelper
  def title(text)
    content_for(:page_title, text)
    content_for(:browser_title, "#{text} - #{Rails.application.class.parent_name} Chunks Admin")
  end
  
  def validation_errors(model)
    raw <<-ERRORS
      <ul class="errors">
        #{model.errors.full_messages.map { |e| "<li>#{e}</li>" }.join}
      </ul>
    ERRORS
  end
end