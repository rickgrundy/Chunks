module Chunks
  class Page < ActiveRecord::Base
    def template
      read_attribute(:template).to_class
    end    
  end
end