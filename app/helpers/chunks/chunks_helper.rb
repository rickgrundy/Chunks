module Chunks::ChunksHelper
  def chunks_logo(size)
    render partial: "chunks/common/logo", locals: {size: size}
  end
end