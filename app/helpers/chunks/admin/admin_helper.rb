module Chunks::Admin::AdminHelper
  def page_title(text)
    content_for(:page_title, text)
    content_for(:browser_title, "#{text} - #{Rails.application.class.parent_name} Chunks Admin")
  end
  
  def chunks_admin_resource_path(model)
    model.new_record? ? send("chunks_admin_#{model.class.table_name}_path") : send("chunks_admin_#{model.class.table_name.singularize}_path", model)
  end
  
  def validation_errors(model, title=nil)
    return if model.errors.empty?
    without_associated_fields = model.errors.reject { |error| error.first.to_s.include?(".") }
    error_messages = without_associated_fields.map do |error| 
      field, msg = *error
      "#{field.to_s.humanize} #{msg}"
    end
    render partial: "chunks/admin/common/errors", locals: {
      title: title || "#{model.class.model_name.demodulize.humanize} could not be saved", 
      error_messages: error_messages
    }
  end
end