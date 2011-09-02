module Chunks::ChunksHelper
  LOGO_PIXELS = [
    [1,1,1, 2, 1,0,0, 2, 0,0,0, 2, 0,0,0, 2, 1,0,0, 2, 0,0,0],
    [1,0,0, 2, 1,0,0, 2, 0,0,0, 2, 0,0,0, 2, 1,0,1, 2, 0,1,1],
    [1,0,0, 2, 1,1,1, 2, 1,0,1, 2, 1,1,1, 2, 1,1,0, 2, 0,1,0],
    [1,1,1, 2, 1,0,1, 2, 1,1,1, 2, 1,0,1, 2, 1,0,1, 2, 1,1,0],
  ]
  PIXEL_CLASS = {0 => "nil", 1 => "pxl", 2 => "spc"}
  
  def chunks_logo(size)
    "<div class=\"logo #{size}\"><h1>Chunks</h1>" +
    LOGO_PIXELS.map do |row|
      '<div class="row">' + row.map do |pixel|
        "<div class=\"#{PIXEL_CLASS[pixel]}\"></div>"
      end.join + '</div>'
    end.join + 
    '<h2 class="row">CONTENT MANAGEMENT ON RAILS</h2></div>'
  end
  
  def admin_resource_path(model)
    model.new_record? ? send("chunks_admin_#{model.class.table_name}_path") : send("chunks_admin_#{model.class.table_name}_path", model)
  end
end