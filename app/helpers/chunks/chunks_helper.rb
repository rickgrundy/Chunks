module Chunks::ChunksHelper
  def chunks_logo(size)
    render partial: "chunks/common/logo", locals: {size: size}
  end
  
  def render_container(container)
    render partial: "chunks/pages/container", locals: {container: container}
  end
  
  def render_chunk(chunk)
    render partial: "chunks/chunks/chunk", locals: {chunk: chunk}
  end
end