module Chunks
  class SharedChunk < ActiveRecord::Base
    belongs_to :chunk
    validates_presence_of :name
    validates_uniqueness_of :name
  end
end