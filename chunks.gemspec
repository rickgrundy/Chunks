# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chunks/version"

Gem::Specification.new do |s|
  s.name        = "chunks"
  s.version     = Chunks::VERSION
  s.platform    = Gem::Platform::RUBY  
  s.rubyforge_project = "chunks"
  s.authors     = ["Rick Grundy"]
  s.email       = ["rick@rickgrundy.com"]
  s.homepage    = "http://www.chunkscms.com"
  s.summary     = %q{Content Management on Rails}
  s.description = <<-EOS
    A CMS for Rails apps which deal with user generated content. 
    Chunks is a Rails engine providing out-of-the-box management and rendering for pages composed of self-contained chunks of content. 
    Each Chunk is comprised of an edit view, a public view, and a view model which will be updated, validated, and invoked by the ChunksController if server-side interaction is required.
    The Chunks controller quickly delegates all responsibility for logic and page flow to an individual Chunk view model while the framework gets out of the way altogether, allowing for extremely easy extension.
    Documentation and extensions available at http://www.chunkscms.com.
  EOS

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'haml'
  s.add_dependency 'will_paginate'
  s.add_dependency 'acts_as_list'
  
  s.add_development_dependency "rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl"
end
