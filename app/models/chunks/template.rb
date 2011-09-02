module Chunks::Template
  def self.all
    $chunks_templates
  end
  
  def self.add(*templates)
    $chunks_templates ||= []
    $chunks_templates += templates
  end
end