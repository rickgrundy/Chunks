module Chunks::ChunksHelper
  LOGO_PIXELS = [
    [1,1,1, 2, 1,0,0, 2, 0,0,0, 2, 0,0,0, 2, 1,0,0, 2, 0,0,0],
    [1,0,0, 2, 1,0,0, 2, 0,0,0, 2, 0,0,0, 2, 1,0,1, 2, 0,1,1],
    [1,0,0, 2, 1,1,1, 2, 1,0,1, 2, 1,1,1, 2, 1,1,0, 2, 0,1,0],
    [1,1,1, 2, 1,0,1, 2, 1,1,1, 2, 1,0,1, 2, 1,0,1, 2, 1,1,0],
  ]
  PIXEL_CLASS = {0 => "nil", 1 => "pxl", 2 => "spc"}
  
  def chunks_logo(size)
    <<-LOGO
      <div class="logo #{size}">
        <h1>Chunks</h1>
        #{logo_rows}
        <h2 class="row">CONTENT MANAGEMENT ON RAILS</h2>
      </div>
    LOGO
  end
  
  def admin_resource_path(model)
    model.new_record? ? send("chunks_admin_#{model.class.table_name}_path") : send("chunks_admin_#{model.class.table_name}_path", model)
  end
  
  private
  
  
  def logo_rows
    LOGO_PIXELS.map { |row| '<div class="row">' + pixels_for_row(row) + '</div>' }.join
  end
  
  def pixels_for_row(row)
    row.map { |pixel| "<div class=\"#{PIXEL_CLASS[pixel]}\"></div>" }.join
  end
end