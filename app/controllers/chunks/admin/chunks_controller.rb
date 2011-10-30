module Chunks::Admin
  class ChunksController < AdminController      
    def create
      page = Chunks::Page.find(params[:page_id])
      @chunk = params[:type].to_class.new(page: page, container_key: params[:container_key])
      @chunk.save!(validate: false)
      redirect_to edit_chunks_admin_page_path(page)
    end
    
    def destroy
      chunk = Chunks::Chunk.find(params[:id])
      chunk.destroy
      redirect_to edit_chunks_admin_page_path(chunk.page)
    end
    
    def move_higher
      chunk = Chunks::Chunk.find(params[:id])
      chunk.move_higher
      redirect_to edit_chunks_admin_page_path(chunk.page)
    end
    
    def move_lower
      chunk = Chunks::Chunk.find(params[:id])
      chunk.move_lower
      redirect_to edit_chunks_admin_page_path(chunk.page)
    end
  end
end