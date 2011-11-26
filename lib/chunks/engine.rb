require 'rails'
require 'acts_as_list'

module Chunks
  class Engine < Rails::Engine
    isolate_namespace Chunks
  end
end