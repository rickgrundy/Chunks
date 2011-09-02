module Chunks::Template 
  class Base
    def self.title(title=nil)
      @title = title unless title.nil?
      @title || self.name.demodulize.titleize
    end
    
    def self.option_for_select
      [self.title, self]
    end
  end
end