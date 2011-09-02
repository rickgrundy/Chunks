module Chunks
  class Chunk < ActiveRecord::Base
    def container_key
      read_attribute(:container_key).to_sym
    end
  end
end