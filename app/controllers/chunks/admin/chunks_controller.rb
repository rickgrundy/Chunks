module Chunks::Admin
  class ChunksController < AdminController  
    def new
      @page = Chunks::Page.find(params[:page_id])
      @chunk = params[:type].to_class.new      
      @page.add_chunk(@chunk, params[:container_key])
      @chunk.errors.clear
      render layout: false
    end
    
    def preview
      chunk_params = params[:chunk] || params[:page][:chunks_attributes].first.last
      @chunk = chunk_params[:id] ? Chunks::Chunk.find(chunk_params[:id]) : chunk_params[:type].to_class.new
      @chunk.usage_context = Chunks::ChunkUsage.new
      @chunk.attributes = chunk_params.except(:type, :id, :_destroy)      
      render layout: "chunks/admin/chunk_preview", nothing: true
    end
    
    def share
      chunk = Chunks::Chunk.find(params[:id])
      if chunk.share(params[:name]).valid?
        render text: "Chunk has been shared."
      else
        render status: :error, json: chunk.shared_chunk.errors.full_messages
      end
    end
  end
end