module Chunks
  class SharedChunk < ActiveRecord::Base
    belongs_to :chunk
    accepts_nested_attributes_for :chunk
    validates_associated :chunk, message: "is invalid (see below)"
    
    validates_presence_of :name
    validates_uniqueness_of :name
    
    def unshare
      self.destroy
    end
  end
end