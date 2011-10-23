module Chunks::Admin::AdminHelper
  def title(text)
    content_for(:page_title, text)
    content_for(:browser_title, "#{text} - #{Rails.application.class.parent_name} Chunks Admin")
  end
  
  def chunks_admin_resource_path(model)
    model.new_record? ? send("chunks_admin_#{model.class.table_name}_path") : send("chunks_admin_#{model.class.table_name.singularize}_path", model)
  end
  
  def validation_errors(model)
    raw <<-ERRORS
      <ul class="errors">
        #{model.errors.full_messages.map { |e| "<li>#{e}</li>" }.join}
      </ul>
    ERRORS
  end
end