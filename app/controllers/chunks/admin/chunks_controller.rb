module Chunks::Admin
  class ChunksController < AdminController  
    def new
      @page = Chunks::Page.find(params[:page_id])
      @chunk = params[:type].to_class.new      
      @page.chunk_usages.build(chunk: @chunk, container_key: params[:container_key])
      @chunk.errors.clear
      render layout: false
    end
    
    def preview
      chunk_params = params[:chunk] || params[:page][:chunks_attributes].first.last
      if chunk_params[:id]
        @chunk = Chunks::Chunk.find(chunk_params[:id])
        @chunk.attributes = chunk_params.except(:type, :id, :_destroy)
      else
        @chunk = chunk_params[:type].to_class.new(chunk_params.except(:type, :id))
      end
      render layout: "chunks/admin/chunk_preview", nothing: true
    end
  end
end