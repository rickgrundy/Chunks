module Chunks::Admin
  class ChunksController < AdminController  
    def new
      @page = Chunks::Page.find(params[:page_id])
      @chunk = params[:type].to_class.new(page: @page, container_key: params[:container_key])      
      @page.chunks << @chunk
      @chunk.errors.clear
      render layout: false
    end
    
    def preview
      chunk_params = params[:chunks_chunk] || params[:chunks_page][:chunks_attributes].first.last
      if chunk_params[:id]
        @chunk = Chunks::Chunk.find(chunk_params[:id])
        @chunk.attributes = chunk_params.except(:type, :id)
      else
        @chunk = chunk_params[:type].to_class.new(chunk_params.except(:type, :id))
      end
      render layout: "chunks/admin/chunk_preview", nothing: true
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