module Chunks::Template
  mattr_accessor :all
  
  def self.add(*templates)
    self.all ||= []
    self.all += templates
  end
end