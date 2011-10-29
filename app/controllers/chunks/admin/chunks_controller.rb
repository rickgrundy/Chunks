module Chunks::Admin
  class ChunksController < AdminController      
    def create
      page = Chunks::Page.find(params[:page_id])
      @chunk = params[:type].to_class.new(page: page, container_key: params[:container_key])
      @chunk.save(validate: false)
      redirect_to edit_chunks_admin_page_path(page)
    end
  end
end